// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
Процедура ОбработкаПроведения(Отказ, Режим)

	// регистр АктуальнаяШкалаБонуснойПрограммы
	Движения.АктуальнаяШкалаБонуснойПрограммы.Записывать = Истина;
	Движение = Движения.АктуальнаяШкалаБонуснойПрограммы.Добавить();
	Движение.Период = Дата;
	Движение.Шкала = Ссылка;
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Если Диапазоны.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	//1. Нижняя граница первого диапазона должна быть равна 0
	Если Диапазоны[0].НижняяГраница <> 0 Тогда
		Отказ =Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст ="Нижняя граница первого диапазона должна быть равна 0";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Поле = "Диапазоны[0].НижняяГраница";
		Сообщение.Сообщить();
	КонецЕсли;
	ВерхняяГраницаПредыдущегоДиапазона = 0;
	Для Сч = 0 По Диапазоны.Количество() - 1 Цикл
		Диапазон = Диапазоны[Сч];
		Если Сч > 0 Тогда
	//2 . Верзняя граница каждого диапазона, кроме последнего, должна быть равна нижней следующего		
			Если Диапазон.НижняяГраница <> ВерхняяГраницаПредыдущегоДиапазона Тогда
				Отказ =Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст ="Верхняя граница диапазона должна быть равна нижней границе следующей";
				Сообщение.УстановитьДанные(ЭтотОбъект);
				Сообщение.Поле = СтрШаблон("Диапазоны[%1].ВерхняяГраница", XMLСтрока(Сч));
				Сообщение.Сообщить();
			КонецЕсли;
		КонецЕсли;
	//3. Верхняя граница всегда больше нижней границы (кроме последнего диапазона)
		Если Диапазон.НижняяГраница >= Диапазон.ВерхняяГраница И Сч <> Диапазоны.Количество() - 1 Тогда
			Отказ =Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст ="Верхняя граница должна быть больше нижней границы";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Поле = СтрШаблон("Диапазоны[%1].ВерхняяГраница", XMLСтрока(Сч));
			Сообщение.Сообщить();
		КонецЕсли;
		ВерхняяГраницаПредыдущегоДиапазона = Диапазон.ВерхняяГраница;
	КонецЦикла;
		
	//4. Верхняя граница последнего диапазона должна быть равна 0
	ПоследнийДиапазон = Диапазоны[Диапазоны.Количество() - 1];
	Если ПоследнийДиапазон.ВерхняяГраница <> 0 Тогда
		Отказ =Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст ="Верхняя граница последнего диапазона должна быть равна 0";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Поле = СтрШаблон("Диапазоны[%1].ВерхняяГраница", XMLСтрока(Диапазоны.Количество() - 1));
		Сообщение.Сообщить();
	КонецЕсли;
КонецПроцедуры
#КонецОбласти

#КонецЕсли
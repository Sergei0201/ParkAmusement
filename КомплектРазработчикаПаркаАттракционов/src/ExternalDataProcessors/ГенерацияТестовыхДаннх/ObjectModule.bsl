// @strict-types
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
    // Рассчитываем каждый день периода
    // В понедельник парк не работает
    // Определяем сколько посетителей придет в парк
    // Коэффициент в выходные жни - 1,5 
    // Выюираем случайных посетителей из списка
    // Для каждого посетителя выбираем на сколько аттракционов он пойдет
    // Проверяем для каждого посещения есть ли билет, если нет - покупаем доступный для нухного аттраукциона
    // Регистрируем посещение
Процедура СгенерироватьДанные() Экспорт
	ТекстМакета = ПолучитьМакет("СлучайныеФИО").ПолучитьТекст();
	СписокПосетителей = СтрРазделить(ТекстМакета, Символы.ПС);

	КоличествоПоситителей = СписокПосетителей.Количество();
	СписокАттракционов = СписокАттракционов();

	ГСЧ = Новый ГенераторСлучайныхЧисел;

	Курсор = Период.ДатаНачала;
	Пока Курсор < Период.ДатаОкончания Цикл
		Если ДеньНедели(Курсор) = 1 Тогда
		    Курсор = Курсор + 86400;
			Продолжить;
		КонецЕсли;

		КоэффициентПоситителей = 1;

		Если ДеньНедели(Курсор) > 6 Тогда
			КоэффициентПоситителей = 1.5;
		КонецЕсли;

		КоличествоПоситителей = ГСЧ.СлучайноеЧисло(10, 30) * КоэффициентПоситителей;

		Для НомерПосетителя = 1 По КоличествоПоситителей Цикл
			ИндексСлучайногоПосетителя = ГСЧ.СлучайноеЧисло(0, 99);
			ФИОПосетителя = СписокПосетителей[ИндексСлучайногоПосетителя];

			Посетитель = ПолучитьПосетителя(ФИОПосетителя);

			СформироватьПосещениеКлиента(Посетитель, Курсор, СписокАттракционов, ГСЧ);
		КонецЦикла;
		Курсор = Курсор + 86400;

	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получить посетителя.
// 
// Параметры:
//  ФИОПосетителя - Строка - ФИОПосетителя
// 
// Возвращаемое значение:
//  Неопределено, СправочникСсылка.Клиенты - Получить посетителя
Функция ПолучитьПосетителя(ФИОПосетителя)

	Результат = Справочники.Клиенты.НайтиПоНаименованию(ФИОПосетителя, Истина);

	Если Не ЗначениеЗаполнено(Результат) Тогда
		СпрОбъект = Справочники.Клиенты.СоздатьЭлемент();
		СпрОбъект.Заполнить(Неопределено);
		СпрОбъект.Наименование = ФИОПосетителя;
		СпрОбъект.Телефон = "89" + СгенерироватьНомерТелефона();
		Если Не СпрОбъект.ПроверитьЗаполнение() Тогда
			ВызватьИсключение "Ошибка создания клиента";
		КонецЕсли;
		СпрОбъект.Записать();
		Результат = СпрОбъект.Ссылка;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Сгенерировать номер телефона.
// 
// Возвращаемое значение:
//  Строка - Сгенерировать номер телефона
Функция СгенерироватьНомерТелефона()
	НомерТелефона = "";
	ГСЧ = Новый ГенераторСлучайныхЧисел;
	Пока СтрДлина(НомерТелефона) < 9 Цикл
		НомерТелефона = НомерТелефона + ГСЧ.СлучайноеЧисло(0, 9);
	КонецЦикла;
	Возврат НомерТелефона;
КонецФункции

// Сформировать посещение клиента.
// 
// Параметры:
//  Посетитель - СправочникСсылка.Клиенты - Посетитель
//  Дата  - Дата - Дата посещения
//  СписокАттракционов - Массив из СправочникСсылка.Аттракционы - Список аттракционов
//  ГСЧ - ГенераторСлучайныхЧисел, Неопределено - ГСЧ
Процедура СформироватьПосещениеКлиента(Посетитель, Дата, СписокАттракционов, ГСЧ = Неопределено)
	Если ГСЧ = Неопределено Тогда
		ГСЧ = Новый ГенераторСлучайныхЧисел;
	КонецЕсли;

	КоличествоАттракционов = ГСЧ.СлучайноеЧисло(1, 7);

	Для Счетчик = 1 По КоличествоАттракционов Цикл
		ИндексАттракциона = ГСЧ.СлучайноеЧисло(0, СписокАттракционов.ВГраница());
		Аттракцион = СписокАттракционов[ИндексАттракциона];

		ОснованиеПосещения = ТекущееОснование(Посетитель, Аттракцион);

		Если Не ЗначениеЗаполнено(ОснованиеПосещения) Тогда
			ОснованиеПосещения = КупитьБилет(Посетитель, Аттракцион, Дата, ГСЧ);
		КонецЕсли;

		ЗарегистрироватьПосещение(ОснованиеПосещения, Аттракцион, Дата);
	КонецЦикла;
КонецПроцедуры

// Зарегистрировать посещение.
// 
// Параметры:
//  ОснованиеПосещения - ДокументСсылка.ПродажаБилета - Основание посещения
//  Аттракцион - СправочникСсылка.Аттракционы - Аттракцион
//  Дата  - Дата - Дата посещения
Процедура ЗарегистрироватьПосещение(ОснованиеПосещения, Аттракцион, Дата)
	ДокОбъект = Документы.ПосещениеАттракциона.СоздатьДокумент();
	ДокОбъект.Заполнить(Неопределено);
	ДокОбъект.Дата = Дата;
	ДокОбъект.Основание = ОснованиеПосещения;
	ДокОбъект.Аттракцион = Аттракцион;

	Если Не ДокОбъект.ПроверитьЗаполнение() Тогда
		ВызватьИсключение "Не удалось записать объект";
	КонецЕсли;

	ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);

КонецПроцедуры

// Купить билет - формирование документ "Прожада билета" 
// 
// Параметры:
//  Посетитель - СправочникСсылка.Клиенты - Посетитель
//  Аттракцион - СправочникСсылка.Аттракционы - Аттракцион
//  Дата - Дата - Дата посещения
//  ГСЧ - ГенераторСлучайныхЧисел - ГСЧ
//  
// 
// Возвращаемое значение:
//  ДокументСсылка.ПродажаБилета
Функция КупитьБилет(Посетитель, Аттракцион, Дата, ГСЧ)
	ДоступнаяНоменклатура = ДоступнаяНоменклатура(Аттракцион);
	ИндексНоменкалатура = ГСЧ.СлучайноеЧисло(0, ДоступнаяНоменклатура.ВГраница());
	Номенклатура = ДоступнаяНоменклатура[ИндексНоменкалатура];

	ДокОбъект = Документы.ПродажаБилета.СоздатьДокумент();
	ДокОбъект.Дата = Дата;
	ДокОбъект.Клиент = Посетитель;

	СтрТабЧасти = ДокОбъект.ПозицииПродажи.Добавить();
	СтрТабЧасти.Номенклатура = Номенклатура; // СправочникСсылка.Номенклатура.
	СтрТабЧасти.Количество = 1;
	СтрТабЧасти.Цена = РегистрыСведений.ЦеныНоменклатуры.ЦенаНоменклатуры(Номенклатура);
	СтрТабЧасти.Сумма = СтрТабЧасти.Цена;

	ДокОбъект.СуммаДокумента = ДокОбъект.ПозицииПродажи.Итог("Сумма");
    ДокОбъект.Записать();
	Если Не ДокОбъект.ПроверитьЗаполнение() Тогда
		ВызватьИсключение "Ошибка создания продажи";
	КонецЕсли;

	ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);

	Возврат ДокОбъект.Ссылка;
КонецФункции

// Доступная номенклатура.
// 
// Параметры:
//  Аттракцион - СправочникСсылка.Аттракционы - Аттракцион
// 
// Возвращаемое значение:
//  Массив из СправочникСсылка.Номенклатура - Доступная номенклатура
Функция ДоступнаяНоменклатура(Аттракцион)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|    Номенклатура.Ссылка
	|ИЗ
	|    Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|    Номенклатура.ВидАттракциона В
	|        (ВЫБРАТЬ
	|            Аттракционы.ВидАттракциона
	|        ИЗ
	|            Справочник.Аттракционы КАК Аттракционы
	|        ГДЕ
	|            Аттракционы.Ссылка = &Аттракцион)";
	Запрос.УстановитьПараметр("Аттракцион", Аттракцион);

	Выборка = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");

	Возврат Выборка;

КонецФункции

// Спсиок аттракционов.
// 
// Возвращаемое значение:
//  СправочникСсылка - Массив из Справочник.Аттракционы - Список аттракционов.
Функция СписокАттракционов()

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|    Аттракционы.Ссылка
	|ИЗ
	|    Справочник.Аттракционы КАК Аттракционы";

	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");

	Возврат Выборка;
КонецФункции

// Текущее основание документ .
// 
// Параметры:
//  Посетитель - СправочникСсылка.Клиенты, Неопределено - Посетитель
//  Аттракцион - Произвольный, СправочникСсылка.Аттракционы - Аттракцион
// 
// Возвращаемое значение:
//  ДокументСсылка - см. Документ.ПосещениеАттракциона, Неопределено - Основание
Функция ТекущееОснование(Посетитель, Аттракцион)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|    АктивныеПосещенияОстатки.Основание
	|ИЗ
	|    РегистрНакопления.АктивныеПосещения.Остатки(, Основание.Клиент = &Посетитель
	|    И ВидАттракциона В
	|        (ВЫБРАТЬ
	|            Аттракционы.ВидАттракциона
	|        ИЗ
	|            Справочник.Аттракционы КАК Аттракционы
	|        ГДЕ
	|            Аттракционы.Ссылка = &Аттракцион)) КАК АктивныеПосещенияОстатки
	|ГДЕ
	|    АктивныеПосещенияОстатки.КоличествоПосещенийОстаток > 0";
	Запрос.УстановитьПараметр("Посетитель", Посетитель);
	Запрос.УстановитьПараметр("Аттракцион", Аттракцион);

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Основание; // см. Документ.ПосещениеАттракциона
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

#КонецОбласти
#КонецЕсли
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.СписокНоменклатуры.Видимость = Ложь;
	Элементы.ДекорацияБаллыКлиента.Видимость = Ложь;
	
	СоздатьДекорацииИзбранныхТоваров();
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура БаллыКСписаниюПриИзменении(Элемент)
	РассчитатьСуммуДокумента();
КонецПроцедуры

&НаКлиенте
Процедура КлиентПриИзменении(Элемент)
	КлиентПриИзменениНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияБаллыКлиентаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка)
	Если СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "#Заполнить_") Тогда
		СтандартнаяОбработка = Ложь;
		БаллыКСписанию = Число(СтрЗаменить(НавигационнаяСсылкаФорматированнойСтроки, "#Заполнить_", ""));
	КонецЕсли;
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПозицииПродажи
&НаКлиенте
Процедура ПозицииПродажиПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	Значение = ПараметрыПеретаскивания.Значение;

	Если ТипЗнч(Значение) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
	ДобавитьУникальныеПозицию(Значение.Номенклатура, Значение.Цена);

КонецПроцедуры

&НаКлиенте
Процедура ПозицииПродажиНоменклатураПриИзменении(Элемент)
	ТекДанные = Элементы.ПозицииПродажи.ТекущиеДанные;
	ТекДанные.Цена = ЦенаНоменклатуры(ТекДанные.Номенклатура);
	РассчитатьСуммуСтроки(ТекДанные);
КонецПроцедуры
&НаКлиенте
Процедура ПозицииПродажиЦенаПриИзменении(Элемент)
	ТекДанные = Элементы.ПозицииПродажи.ТекущиеДанные;
	РассчитатьСуммуСтроки(ТекДанные);
КонецПроцедуры

&НаКлиенте
Процедура ПозицииПродажиКоличествоПриИзменении(Элемент)
	ТекДанные = Элементы.ПозицииПродажи.ТекущиеДанные;
	РассчитатьСуммуСтроки(ТекДанные);
КонецПроцедуры

&НаКлиенте
Процедура ПозицииПродажиПриИзменении(Элемент)
	РассчитатьСуммуДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ПозицииПродажиПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокНоменклатуры

&НаКлиенте
Процедура СписокНоменклатурыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	ДанныеСтроки = Элемент.ТекущиеДанные;
	Если ДанныеСтроки.ЭтоГруппа Тогда
		Выполнение = Ложь;
		Возврат;
	КонецЕсли;

	Значение = Новый Структура;
	Значение.Вставить("Номенклатура", ДанныеСтроки.Номенклатура);
	Значение.Вставить("Цена", ДанныеСтроки.Цена);

	ПараметрыПеретаскивания.Значение = Значение;
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	ДанныеСтроки = Элемент.ТекущиеДанные;
	Если ДанныеСтроки.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;

	ДобавитьУникальныеПозицию(ДанныеСтроки.Номенклатура, ДанныеСтроки.Цена);

КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы

// Код процедур и функций
&НаКлиенте
Процедура ЗаписатьПродажу(Команда)
	НовыйДокумент = ЗаписатьПродажуНаСервере();

	ОповеститьОбИзменении(НовыйДокумент);

	ПоказатьОповещениеПользователя("Создан Документ", ПолучитьНавигационнуюСсылку(НовыйДокумент), Строка(НовыйДокумент));
	ПозицииПродажи.Очистить();
	СуммаИтого = 0;
	БаллыКСписанию = 0;
	Элементы.ДекорацияБаллыКлиента.Видимость = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	Элементы.СписокНоменклатуры.Видимость = Не Элементы.СписокНоменклатуры.Видимость;
	Элементы.ПозицииПродажиПодбор.Пометка = Элементы.СписокНоменклатуры.Видимость;
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДобавитьУникальныеПозицию(Номенклатура, Цена)

	Фильтр = Новый Структура;
	Фильтр.Вставить("Номенклатура", Номенклатура);

	НайденнаяСтрока = ПозицииПродажи.НайтиСтроки(Фильтр);
	Если НайденнаяСтрока.Количество() <> 0 Тогда
		Возврат;
	КонецЕсли;

	Строка = ПозицииПродажи.Добавить();
	Строка.Номенклатура = Номенклатура;
	Строка.Цена = Цена;
	Строка.Количество = 1;
	Строка.Сумма = Строка.Цена;

	РассчитатьСуммуДокумента();

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЦенаНоменклатуры(Знач Номенклатура)

	Возврат РегистрыСведений.ЦеныНоменклатуры.ЦенаНоменклатуры(Номенклатура, ТекущаяДатаСеанса());

КонецФункции

&НаКлиенте
Процедура РассчитатьСуммуСтроки(ДанныеСтроки)
	ДанныеСтроки.Сумма = ДанныеСтроки.Количество * ДанныеСтроки.Цена;
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммуДокумента()
	СуммаИтого = ПозицииПродажи.Итог("Сумма") - БаллыКСписанию;
	ЗаполнитьДекорациюБаллыКлиента();
КонецПроцедуры

&НаСервере
Функция ЗаписатьПродажуНаСервере()

	ДокОбъект = Документы.ПродажаБилета.СоздатьДокумент();

	ДокОбъект.Заполнить(Неопределено);

	ДокОбъект.Клиент = Клиент;
	ДокОбъект.Дата = ТекущаяДатаСеанса();
	ДокОбъект.ПозицииПродажи.Загрузить(ПозицииПродажи.Выгрузить());
	ДокОбъект.БаллыКСписанию = БаллыКСписанию;
	ДокОбъект.СуммаДокумента = СуммаИтого - БаллыКСписанию;
	Если Не ДокОбъект.ПроверитьЗаполнение() Тогда
		ВызватьИсключение "Не удалось записать продажу";
	КонецЕсли;

	ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
	Возврат ДокОбъект.Ссылка;

КонецФункции

&НаСервере
Процедура КлиентПриИзменениНаСервере()
	
	ЗаполнитьДекорациюБаллыКлиента();

	ЗаполнитьИзбранныеТоварыКлиента();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИзбранныеТоварыКлиента()
	СброситьИзбранныеТовары();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 3
				   |	ПродажиОбороты.Номенклатура,
				   |	ПродажиОбороты.СуммаОборот КАК СуммаОборот
				   |ИЗ
				   |	РегистрНакопления.Продажи.Обороты(&НачалоПериода, &КонецПериода,, Клиент = &Клиент) КАК ПродажиОбороты
				   |
				   |УПОРЯДОЧИТЬ ПО
				   |	СуммаОборот УБЫВ";
	Запрос.УстановитьПараметр("НачалоПериода", ДобавитьМесяц(ТекущаяДатаСеанса(), -3));
	Запрос.УстановитьПараметр("КонецПериода", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("Клиент", Клиент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Счетчик = 0;
	
	Пока Выборка.Следующий() Цикл
		ТекущаяСтрока = ДинамическиеЭлементы[Счетчик];
		ТекущаяСтрока.Активность = Истина;
		ТекущаяСтрока.Номенклатура = Выборка.Номенклатура;
		Счетчик = Счетчик + 1;
	КонецЦикла;
	
	ЗаполнитьДекорацииИзбранныхТоваров();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДекорацииИзбранныхТоваров()

	Для  Каждого Строка Из ДинамическиеЭлементы Цикл
		Элемент = Элементы[Строка.ИмяЭлемента];
		Элемент.Видимость = Строка.Активность;
		Элемент.Заголовок = Строка.Номенклатура;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СброситьИзбранныеТовары();
	
	Для Каждого Строка Из ДинамическиеЭлементы Цикл
		Строка.Активность = Ложь;
		Строка.Номенклатура = Справочники.Номенклатура.ПустаяСсылка();
	КонецЦикла;
	
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьДекорациюБаллыКлиента()
	Если Не ЗначениеЗаполнено(Клиент) Тогда
		Элементы.ДекорацияБаллыКлиента.Видимость = Ложь;
		Возврат;
	КонецЕсли;

	Элементы.ДекорацияБаллыКлиента.Видимость = Истина;

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	БонусныеБаллыКлиентовОстатки.СуммаОстаток
	|ИЗ
	|	РегистрНакопления.БонусныеБаллыКлиентов.Остатки(,Клиент = &Клиент) КАК БонусныеБаллыКлиентовОстатки";
	Запрос.УстановитьПараметр("Клиент", Клиент);

	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() Тогда
		ОстатокБаллов = Выборка.СуммаОстаток;
	Иначе
		ОстатокБаллов = 0;
	КонецЕсли;

	Если ОстатокБаллов = 0 Тогда
		Элементы.ДекорацияБаллыКлиента.Заголовок = "У клиента нет начисленных баллов";
		Возврат;
	КонецЕсли;
	МаксимальнаяДоля = Константы.МаксимальнаяДоляОплатыБаллами.Получить();
	МаксимумБаловКСписанию = Мин(ОстатокБаллов, СуммаИтого * МаксимальнаяДоля / 100);

	Шаблон = "Накоплено %1 баллов, из ник можно списать %2. ";
	Описание = СтрШаблон(Шаблон, ОстатокБаллов, МаксимумБаловКСписанию);

	ШаблонСсылки = "#Заполнить_%1";
	СсылкаЗаполненияБаллов = СтрШаблон(ШаблонСсылки, XMLСтрока(МаксимумБаловКСписанию));

	ЧастиФорматированнойСтроки = Новый Массив;
	ЧастиФорматированнойСтроки.Добавить(Описание);
	ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока("Заполнить.", , , , СсылкаЗаполненияБаллов));
	Элементы.ДекорацияБаллыКлиента.Заголовок = Новый ФорматированнаяСтрока(ЧастиФорматированнойСтроки);

КонецПроцедуры

&НаСервере
Процедура СоздатьДекорацииИзбранныхТоваров()
		
	КоличествоИзбранныхТоваров = 3;
	Для Сч = 1 По КоличествоИзбранныхТоваров Цикл
		
		ИмяДекораци = "ДекорацияИзбранныхТоваро_" + XMLСтрока(Сч);
		Декорация = Элементы.Добавить(ИмяДекораци,Тип("ДекорацияФормы"), Элементы.ГруппаПопулярныеПокупки);
		Декорация.Вид = ВидДекорацииФормы.Надпись;
		Декорация.Видимость = Ложь;
		Декорация.Гиперссылка = Истина;
		Декорация.УстановитьДействие("Нажатие","Подключаемы_ДекорацияИзбранныхТоваровНажатие");
		СтрокаОписанияДекорации = ДинамическиеЭлементы.Добавить();
		СтрокаОписанияДекорации.ИмяЭлемента = ИмяДекораци;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемы_ДекорацияИзбранныхТоваровНажатие(Элменет)
	ИмяЭлемента = Элменет.Имя;
	Фильтр = Новый Структура("ИмяЭлемента", ИмяЭлемента);
	НайденныеСтроки = ДинамическиеЭлементы.НайтиСтроки(Фильтр);
	
	Если НайденныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Строка = НайденныеСтроки[0];
	Номенклатура = Строка.Номенклатура;
	
	ДобавитьУникальныеПозицию(Номенклатура, ЦенаНоменклатуры(Номенклатура));
	
КонецПроцедуры	
#КонецОбласти
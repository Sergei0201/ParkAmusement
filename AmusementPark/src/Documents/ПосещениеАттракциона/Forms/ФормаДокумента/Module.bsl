
#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Код процедур и функций

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Код процедур и функций


&НаКлиенте
Процедура ОснованиеПриИзменении(Элемент)
	ОснованиеПриИзмененииНаСервере();
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

// Код процедур и функций

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОснованиеПриИзмененииНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПродажаБилета.Аттракцион
	|ИЗ
	|	Документ.ПродажаБилета КАК ПродажаБилета
	|ГДЕ
	|	ПродажаБилета.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Объект.Основание);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Объект.Аттракцион = Выборка.Аттракцион;
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("УникальныйИдентификаторФормыВладельца", УникальныйИдентификаторФормыВладельца);
	
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("Организация", Параметры.Организация);
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("МассивПоступлений", Параметры.МассивПоступлений);
	
	// РаботаСФормами
	РаботаСФормамиСервер.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец РаботаСФормами
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокДокументовВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("МассивДокументов", 	ПолучитьСписокВыбранныхДокументов(Значение));  
	Оповестить("ПодборДокументаПоступления", СтруктураВозврата, УникальныйИдентификаторФормыВладельца);
	Закрыть();
КонецПроцедуры

Функция ПолучитьСписокВыбранныхДокументов(МассивСтрок)

	Схема = Элементы.СписокДокументов.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.СписокДокументов.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);

	МассивДокументов = Новый Массив();
	
	Для Каждого Номер Из МассивСтрок Цикл
		МассивДокументов.Добавить(Результат.Получить(Номер - 1).Ссылка);		
	КонецЦикла;	
	
	Возврат МассивДокументов;
КонецФункции


#КонецОбласти

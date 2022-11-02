#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	Настройки.ПриНачальномЗаполненииЭлемента = Ложь;
	
КонецПроцедуры

// Вызывается при начальном заполнении справочника.
//
// Параметры:
//  КодыЯзыков - Массив - список языков конфигурации. Актуально для мультиязычных конфигураций.
//  Элементы   - ТаблицаЗначений - данные заполнения. Состав колонок соответствует набору реквизитов
//                                 справочника ПапкиФайлов.
//  ТабличныеЧасти - Структура - описание табличных частей объекта, где:
//   * Ключ - Строка - имя табличной части;
//   * Значение - ТаблицаЗначений - табличная часть в виде таблицы значений, структуру которой
//                                  необходимо скопировать перед заполнением. Например:
//                                  Элемент.Ключи = ТабличныеЧасти.Ключи.Скопировать();
//                                  ЭлементТЧ = Элемент.Ключи.Добавить();
//                                  ЭлементТЧ.ИмяКлюча = "Первичный";
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	// Добавление колонки ставка для заполнения РС Ставки налога на имущество.
	Элементы.Колонки.Добавить("Ставка", ОбщегоНазначения.ОписаниеТипаЧисло(10, 2));
	
	СправочникМенеджер = Справочники.ГруппыИмущества;
	
	КлассификаторXML = СправочникМенеджер.ПолучитьМакет("МакетЗаполнения").ПолучитьТекст();
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	Для Каждого СтрокаТаблицыЗначений Из КлассификаторТаблица Цикл
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("ИмяПредопределенныхДанных", СтрокаТаблицыЗначений.ИмяПредопределенныхДанных);
		ЗначенияЗаполнения.Вставить("Предопределенный", Истина);
		ЗначенияЗаполнения.Вставить("Код", СтрокаТаблицыЗначений.ИмяПредопределенныхДанных);
		ЗначенияЗаполнения.Вставить("Наименование", СтрокаТаблицыЗначений.Наименование);
		ЗначенияЗаполнения.Вставить("НаименованиеПолное", СтрокаТаблицыЗначений.НаименованиеПолное);
		ЗначенияЗаполнения.Вставить("Ставка", СтрокаТаблицыЗначений.Ставка);
		
		Элемент = Элементы.Добавить();
		ЗаполнитьЗначенияСвойств(Элемент, ЗначенияЗаполнения);
	КонецЦикла;
	
КонецПроцедуры

// Вызывается при начальном заполнении элемента.
//
// Параметры:
//  Объект                  - СправочникОбъект.ГруппыИмущества - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения.
//  ДополнительныеПараметры - Структура - Дополнительные параметры.
//
Процедура ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры) Экспорт
	
	// Добавление записей в РС Ставки налога на имущество.
	МенеджерЗаписи = РегистрыСведений.СтавкиНалогаНаИмущество.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Период = '2009.01.01';
	МенеджерЗаписи.ГруппаНалогаНаИмущество = Объект.Ссылка;
	МенеджерЗаписи.Ставка = Данные.Ставка;
	МенеджерЗаписи.Записать();
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли
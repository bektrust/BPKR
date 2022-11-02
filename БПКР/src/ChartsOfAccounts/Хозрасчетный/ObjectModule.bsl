#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Предопределенный 
		И Родитель <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Родитель") Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru='Нельзя изменять подчиненность предопределенных счетов.'"), ЭтотОбъект, "Родитель", , Отказ);
	КонецЕсли;
	
	// Особенность учета в Рег.бух.
	// Признаки субконто лучше включать.
	Для Каждого СтрокаСубконто Из ВидыСубконто Цикл 
		Если НЕ Валютный И НЕ СтрокаСубконто.Валютный Тогда 
			СтрокаСубконто.Валютный = Истина;
		КонецЕсли;
		Если Не Количественный И НЕ СтрокаСубконто.Количественный Тогда 
			СтрокаСубконто.Количественный = Истина;
		КонецЕсли;	
	КонецЦикла;		
	
	Порядок = ПолучитьПорядокКода();

КонецПроцедуры

// Процедура - обработчик события ПриЗаписи объекта.
//
Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;		
	КонецЕсли;

	ОбновитьПовторноИспользуемыеЗначения();
	
	
КонецПроцедуры

// Процедура - обработчик события ПриКопировании объекта.
//
Процедура ПриКопировании(ОбъектКопирования)
	ПарныйСчет = ПланыСчетов.Хозрасчетный.ПустаяСсылка();	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
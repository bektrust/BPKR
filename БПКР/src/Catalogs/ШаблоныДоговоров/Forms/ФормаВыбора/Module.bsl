
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Не ПравоДоступа("Редактирование", Метаданные.Справочники.ШаблоныДоговоров) Тогда
		Элементы.ГруппаСоздать.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьДоговорПоставки(Команда)
	
	ОткрытьВыбранныйШаблон("ДоговорПоставки");
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДоговорОказанияУслуг(Команда)
	
	ОткрытьВыбранныйШаблон("ДоговорОказанияУслуг");
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДоговорПодряда(Команда)
	
	ОткрытьВыбранныйШаблон("ДоговорПодряда");
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовыйШаблон(Команда)
	
	ОткрытьВыбранныйШаблон("");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПолучитьСтруктуруПараметровФормы(ВыбранныйМакет)
	
	СтруктураПараметров = Новый Структура;
	
	ЗначенияЗаполнения = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
	
	ЗначенияЗаполнения.Вставить("ИмяМакета", ВыбранныйМакет);
	
	СтруктураПараметров.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьВыбранныйШаблон(ВыбранныйМакет)
	
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(ВыбранныйМакет);
	
	ОткрытьФорму("Справочник.ШаблоныДоговоров.Форма.ФормаРедактированияШаблона", СтруктураПараметров, ВладелецФормы);
	
КонецПроцедуры

#КонецОбласти
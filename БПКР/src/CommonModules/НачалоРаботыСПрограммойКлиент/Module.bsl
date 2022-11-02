
#Область СлужебныйИнтерфейс

Процедура ИнтерфейсНачалоРаботы(ПараметрыНачалаРаботы) Экспорт
	
	ОткрытьФормуНачалаРаботыСПрограммой(ПараметрыНачалаРаботы);
	
КонецПроцедуры

Процедура ПараметрыОткрытияФормы(ПараметрыОткрытия, ПараметрыНачалаРаботы)
	
	ПараметрыОткрытия = Новый Структура;
	НачалоРаботыСПрограммойКлиентПереопределяемый.ДозаполнитьПараметрыОткрытияФормы(ПараметрыОткрытия, ПараметрыНачалаРаботы);
	
КонецПроцедуры

Процедура ОписанияОповещенияЗакрытияФормы(ОписаниеОповещения, ПараметрыНачалаРаботы)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаЗакрытияФормыНачалаРаботы", НачалоРаботыСПрограммойКлиент, ПараметрыНачалаРаботы);
	НачалоРаботыСПрограммойКлиентПереопределяемый.ПереопределитьОписанияОповещенияЗакрытияФормы(ОписаниеОповещения, ПараметрыНачалаРаботы);
	
КонецПроцедуры

Процедура ОткрытьФормуНачалаРаботыСПрограммой(ПараметрыНачалаРаботы)
	Перем ПараметрыОткрытия, ОписаниеОповещения;
	
	ПараметрыОткрытияФормы(ПараметрыОткрытия, ПараметрыНачалаРаботы);
	ОписанияОповещенияЗакрытияФормы(ОписаниеОповещения, ПараметрыНачалаРаботы);
	
	ОткрытьФорму("Обработка.НачалоРаботыСПрограммой.Форма", ПараметрыОткрытия, , , , , ОписаниеОповещения);
	
КонецПроцедуры

Процедура ОбработкаЗакрытияФормыНачалаРаботы(Результат, ПараметрыНачалаРаботы) Экспорт
	Перем ОбработкаЗавершена;
	
	Если Результат = Неопределено Тогда
		
		ЗавершитьРаботуСистемы(Ложь, Ложь);
		
	ИначеЕсли ТипЗнч(Результат) = Тип("Структура") Тогда
		
		Если НЕ Результат.ДополнительныйПараметр = НачалоРаботыСПрограммойСервер.ЗначениеДополнительногоПараметра() Тогда
			
			Если Результат.НачатьРаботу <> Истина Тогда
				
				ЗавершитьРаботуСистемы(Ложь, Ложь)
				
			КонецЕсли;
			
			НачалоРаботыСПрограммойКлиентПереопределяемый.ОбработкаЗакрытияФормыНачалаРаботыНаКлиенте(Результат, ПараметрыНачалаРаботы, ОбработкаЗавершена);
			НачалоРаботыСПрограммойПереопределяемый.ОбработкаЗакрытияФормыНачалаРаботы(Результат, ПараметрыНачалаРаботы, ОбработкаЗавершена);
			
			Если ОбработкаЗавершена = Истина Тогда
				
				Если НЕ ПараметрыНачалаРаботы.ПараметрыРаботыКлиента.РазделениеВключено Тогда
					
					ДополнительныеПараметрыКоманднойСтроки = "";
					Если Результат.Свойство("ПользовательИмя") Тогда
						
						ДополнительныеПараметрыКоманднойСтроки = "/N" + """" + Результат.ПользовательИмя + """";
						
					КонецЕсли;
					
					ЗавершитьРаботуСистемы(Ложь, Истина, ДополнительныеПараметрыКоманднойСтроки);
					
				Иначе
					ОбновитьИнтерфейс();
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#конецОбласти
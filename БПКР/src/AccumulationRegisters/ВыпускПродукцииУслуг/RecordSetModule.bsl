#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
		
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Приведем значения СубконтоСписания1, СубконтоСписания2, СубконтоСписания3 
	// в соответствие СчетСписания.
	// Модифицируем набор только когда действительно нужно внести изменения.
	
	КоличествоСубконтоВРегистре = 3;
	КоличествоСубконтоСписания = Мин(КоличествоСубконтоВРегистре, БухгалтерскийУчетСервер.МаксимальноеКоличествоСубконто());
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		Если Не ЗначениеЗаполнено(Запись.СчетСписания) Тогда
			Продолжить;
		КонецЕсли;
		
		СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Запись.СчетСписания);
		
		Для НомерСубконто = 1 По КоличествоСубконтоСписания Цикл
			
			ИмяПоля = "СубконтоСписания" + НомерСубконто;
			
			ЗначениеСубконто = Запись[ИмяПоля];
			
			Если НомерСубконто > СвойстваСчета.КоличествоСубконто Тогда
				
				ЗначениеСубконто = Неопределено;
				
			Иначе	
				
				ИмяСвойстваТипЗначения = "ВидСубконто" + НомерСубконто + "ТипЗначения"; // См. ПолучитьСвойстваСчета()
				ТипСубконто = СвойстваСчета[ИмяСвойстваТипЗначения];
				
				Если Не ЗначениеЗаполнено(ЗначениеСубконто) И ТипСубконто.Типы().Количество() > 1 Тогда
					ЗначениеСубконто = Неопределено;
				Иначе
					ЗначениеСубконто = ТипСубконто.ПривестиЗначение(ЗначениеСубконто);
				КонецЕсли;
				
			КонецЕсли;
			
			Если Запись[ИмяПоля] <> ЗначениеСубконто Тогда
				Запись[ИмяПоля] = ЗначениеСубконто;
			КонецЕсли;
			
		КонецЦикла; // По субконто
		
	КонецЦикла; // По записям
	
КонецПроцедуры

#КонецОбласти
	
#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
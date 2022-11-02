
#Область ПрограммныйИнтерфейс

// Процедура устанавливает курс валюты взаиморасчета документа
// Если валюты документа и расчета разные, то курс взаиморасчетов равен отношению большего курса на меньший.
//
// Параметры:
//  Объект					- Объект - Объект пересчета
//  ДанныеДокумента			- Структура - Данные документа
//		* Валюта	- СправочникСсылка.Валюты - Валюта документа
//		* Курс		- Число - Курс документа
//		* Кратность - Число - Кратность документа
//  ДанныВзаиморасчетов	- Структура - Данные взаиморасчетов
//		* Валюта	- СправочникСсылка.Валюты - Валюта расчетов
//		* Курс		- Число - Курс расчетов
//		* Кратность - Число - Кратность документа
//
Процедура УстановитьКурсыВзаиморасчетов(Объект, ДанныеДокумента, ДанныВзаиморасчетов) Экспорт
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();

	Если ДанныеДокумента.Валюта = ВалютаРегламентированногоУчета
		И ДанныВзаиморасчетов.Валюта = ВалютаРегламентированногоУчета Тогда 
		Объект.КурсВзаиморасчетов = ДанныеДокумента.Курс;
		Объект.КратностьВзаиморасчетов = ДанныеДокумента.Кратность;
	// 2. Валюта документа USD, валюта расчетов USD.
	ИначеЕсли НЕ ДанныеДокумента.Валюта = ВалютаРегламентированногоУчета
		И ДанныВзаиморасчетов.Валюта = ДанныеДокумента.Валюта Тогда
		Объект.КурсВзаиморасчетов = ДанныеДокумента.Курс;
		Объект.КратностьВзаиморасчетов = ДанныеДокумента.Кратность;
	// 3. Валюта документа KGS, валюта расчетов USD.
	ИначеЕсли ДанныеДокумента.Валюта = ВалютаРегламентированногоУчета
		И НЕ ДанныВзаиморасчетов.Валюта = ВалютаРегламентированногоУчета Тогда
		Объект.КурсВзаиморасчетов = ДанныВзаиморасчетов.Курс;
		Объект.КратностьВзаиморасчетов = ДанныВзаиморасчетов.Кратность;
		Объект.ПрямойКурс = Ложь;
	// 4. Валюта документа USD, валюта расчетов KGS.
	ИначеЕсли НЕ ДанныеДокумента.Валюта = ВалютаРегламентированногоУчета
		И ДанныВзаиморасчетов.Валюта = ВалютаРегламентированногоУчета Тогда
		Объект.КурсВзаиморасчетов = ДанныеДокумента.Курс;
		Объект.КратностьВзаиморасчетов = ДанныеДокумента.Кратность;
		Объект.ПрямойКурс = Истина;
	// 5. Валюта документа USD, валюта расчетов RUB.
	ИначеЕсли НЕ ДанныеДокумента.Валюта = ВалютаРегламентированногоУчета
		И НЕ ДанныВзаиморасчетов.Валюта = ВалютаРегламентированногоУчета Тогда
		
		Если ДанныеДокумента.Курс >= ДанныВзаиморасчетов.Курс 
			И ДанныеДокумента.Кратность >= ДанныВзаиморасчетов.Кратность Тогда 
			Если ДанныВзаиморасчетов.Курс * ДанныеДокумента.Кратность = 0 Тогда 
				Объект.КурсВзаиморасчетов = 0;
			Иначе 			
				Объект.КурсВзаиморасчетов = ДанныеДокумента.Курс * ДанныВзаиморасчетов.Кратность / ДанныВзаиморасчетов.Курс * ДанныеДокумента.Кратность;
			КонецЕсли;
			
			Объект.КратностьВзаиморасчетов = 1;
			Объект.ПрямойКурс = Истина;
		Иначе
			Если ДанныеДокумента.Курс * ДанныВзаиморасчетов.Кратность = 0 Тогда 
				Объект.КурсВзаиморасчетов = 0;
			Иначе 	
				Объект.КурсВзаиморасчетов = ДанныВзаиморасчетов.Курс * ДанныеДокумента.Кратность / ДанныеДокумента.Курс * ДанныВзаиморасчетов.Кратность;
			КонецЕсли;
			
			Объект.КратностьВзаиморасчетов = 1;
			Объект.ПрямойКурс = Ложь;
		КонецЕсли;	
	КонецЕсли;
	
	// Обновление данных структуры.
	ДанныеДокумента.ПрямойКурс = Объект.ПрямойКурс;
	ДанныВзаиморасчетов.Курс = Объект.КурсВзаиморасчетов; 
	ДанныВзаиморасчетов.Кратность = Объект.КратностьВзаиморасчетов; 	

КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Проверяет активна ли кассовая смена. Под активностью понимается соблюдение следующих условий:
// кассовая смена не закрыта с момента открытия кассовой смены прошло не более 24 часов.
//
// Параметры:
//  КассоваяСмена - ДокументСсылка.КассоваяСмена - Кассовая смена, активность которой необходимо проверить
//
// Возвращаемое значение:
//  Булево - активность смены
Функция СменаАктивна(КассоваяСмена) Экспорт
	
	ОписаниеСмены = ОписаниеКассовойСмены(КассоваяСмена);
	
	Если ОписаниеСмены = Неопределено Тогда
		Возврат Ложь;
	ИначеЕсли ОписаниеСмены.Статус = Перечисления.СтатусыКассовойСмены.Открыта
		И ОписаниеСмены.ДатаИстеченияСрокаДействия > МенеджерОборудованияВызовСервера.ДатаСеанса() Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Проверяет закрыта ли кассовая смена.
//
// Параметры:
//  КассоваяСмена - ДокументСсылка.КассоваяСмена - Кассовая смена, активность которой необходимо проверить
//
// Возвращаемое значение:
//  Булево - Истина - смена закрыта, Ложь - смена не закрыта
Функция СменаЗакрыта(КассоваяСмена) Экспорт
	
	ОписаниеПоследнейСмены = ОписаниеКассовойСмены(КассоваяСмена);
	
	Если ОписаниеПоследнейСмены = Неопределено Тогда
		Возврат Истина;
	ИначеЕсли Не ОписаниеПоследнейСмены.Статус = Перечисления.СтатусыКассовойСмены.Открыта Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Получает реквизиты кассовой смены
//
// Параметры:
//  КассоваяСмена - ДокументСсылка.КассоваяСмена - Кассовая смена, активность которой необходимо проверить
//
// Возвращаемое значение:
//  Структура - реквизиты кассовой смены. Содержит следующие реквизиты:
//    *КассоваяСмена - ДокументСсылка.КассоваяСмена - ссылка на кассовую смену
//    *ФискальноеУстройство - СправочникСсылка.ПодключаемоеОборудование - ссылка на устройство, на котором открыта смена
//    *НачалоКассовойСмены - Дата - дата открытия смены
//    *ОкончаниеКассовойСмены - Дата - дата закрытия смены (если смена закрывалась)
//    *ДатаИстеченияСрокаДействия - Дата - в которую закончиться срок действия смены (дата открытия + 24 часа)
//    *Организация - ОпределяемыйТип.ОрганизацияБПО - организация, указанная в документе КассоваяСмена
//    *Статус - ПеречислениеСсылка.СтатусыКассовойСмены - статус кассовой смены.
Функция ОписаниеКассовойСмены(КассоваяСмена) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	КассоваяСмена.Ссылка КАК КассоваяСмена,
	|	КассоваяСмена.ФискальноеУстройство,
	|	КассоваяСмена.НачалоКассовойСмены,
	|	КассоваяСмена.ОкончаниеКассовойСмены,
	|	ДОБАВИТЬКДАТЕ(КассоваяСмена.НачалоКассовойСмены, ДЕНЬ, 1) КАК ДатаИстеченияСрокаДействия,
	|	КассоваяСмена.Организация,
	|	КассоваяСмена.Статус
	|ИЗ
	|	Документ.КассоваяСмена КАК КассоваяСмена
	|ГДЕ
	|	КассоваяСмена.Ссылка = &КассоваяСмена";
	Запрос.УстановитьПараметр("КассоваяСмена", КассоваяСмена);
	Результат = Запрос.Выполнить().Выгрузить();
	
	Если Результат.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		СтруктураРезультат = Новый Структура();
		Для Каждого КолонкаРезультата Из Результат.Колонки Цикл
			СтруктураРезультат.Вставить(КолонкаРезультата.Имя, Результат[0][КолонкаРезультата.Имя]);
		КонецЦикла;
		Возврат СтруктураРезультат;
	КонецЕсли;
	
КонецФункции

// По фискальному устройству определяет статус смены и проверяет ее активность. Под активностью понимается соблюдение следующих условий:
// - кассовая смена не закрыта с момента открытия кассовой смены прошло не более 24 часов.
//
// Параметры:
//  ФискальноеУстройство - СправочникСсылка.ПодключаемоеОборудование - фискальное устройство, для которого требуется определить активность смены
//
// Возвращаемое значение:
//  Структура:
//    *Открыта - Булево - Истина - смена открыта, Ложь - смена закрыта.
//    *Активна - Булево - Истина - смена открыта, Ложь - смена закрыта, прошло более 24 часов с момента открытия или никогда не была открыта.
//    *ТекущийНомерЧека - Число - текущий номер чека ККТ.
// 
Функция СтатусПоследнейСмены(ФискальноеУстройство) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	РезультатОперации = Новый Структура();
	РезультатОперации.Вставить("Активна", Ложь);
	РезультатОперации.Вставить("Открыта", Ложь);
	РезультатОперации.Вставить("ТекущийНомерЧека");
	РезультатОперации.Вставить("НомерСмены");
	РезультатОперации.Вставить("КассоваяСмена");
	РезультатОперации.Вставить("НомерСменыККТ");
	РезультатОперации.Вставить("ДатаИстеченияСрокаДействия");
	   
	ОписаниеПоследнейСмены = ОписаниеПоследнейКассовойСмены(ФискальноеУстройство);
	
	Если Не (ОписаниеПоследнейСмены = Неопределено) Тогда
		РезультатОперации.Открыта = ОписаниеПоследнейСмены.Статус = Перечисления.СтатусыКассовойСмены.Открыта; 
		РезультатОперации.Активна = РезультатОперации.Открыта 
			И ОписаниеПоследнейСмены.ДатаИстеченияСрокаДействия > МенеджерОборудованияВызовСервера.ДатаСеанса();
		РезультатОперации.КассоваяСмена    = ОписаниеПоследнейСмены.КассоваяСмена;
		РезультатОперации.НомерСмены       = ОписаниеПоследнейСмены.КассоваяСмена.Номер;
		РезультатОперации.НомерСменыККТ    = ОписаниеПоследнейСмены.КассоваяСмена.НомерСменыККТ;
		РезультатОперации.ДатаИстеченияСрокаДействия = ОписаниеПоследнейСмены.ДатаИстеченияСрокаДействия;
	КонецЕсли;
	
	Возврат РезультатОперации;
	
КонецФункции

// По фискальному устройству определяет последнюю смену и проверяет закрыта ли она.
//
// Параметры:
//  ФискальноеУстройство - СправочникСсылка.ПодключаемоеОборудование - фискальное устройство, для которого требуется определить закрыта ли смена
//
// Возвращаемое значение:
//  Булево - Истина - смена закрыта или никогда не была открыта, Ложь - смена не закрыта
Функция ПоследняяСменаЗакрыта(ФискальноеУстройство) Экспорт
	
	ОписаниеПоследнейСмены = ОписаниеПоследнейКассовойСмены(ФискальноеУстройство);
	
	Если ОписаниеПоследнейСмены = Неопределено Тогда
		
		Возврат Истина;
		
	ИначеЕсли Не ОписаниеПоследнейСмены.Статус = Перечисления.СтатусыКассовойСмены.Открыта Тогда
		
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

// По фискальному устройству определяет последнюю смену и получает ее реквизиты.
//
// Параметры:
//  ФискальноеУстройство - СправочникСсылка.ПодключаемоеОборудование - фискальное устройство, для которого требуется определить активность смены.
//
// Возвращаемое значение:
//  Структура - реквизиты кассовой смены, Неопределено - если ни одной смены не было открыто. Содержит следующие реквизиты:
//    *КассоваяСмена - ДокументСсылка.КассоваяСмена - ссылка на кассовую смену
//    *ФискальноеУстройство - СправочникСсылка.ПодключаемоеОборудование - ссылка на устройство, на котором открыта смена
//    *НачалоКассовойСмены - Дата - дата открытия смены
//    *ОкончаниеКассовойСмены - Дата - дата закрытия смены (если смена закрывалась)
//    *ДатаИстеченияСрокаДействия - Дата - в которую закончиться срок действия смены (дата открытия + 24 часа)
//    *Организация - ОпределяемыйТип.ОрганизацияБПО - организация, указанная в документе КассоваяСмена.
//    *Статус - ПеречислениеСсылка.СтатусыКассовойСмены - статус кассовой смены.
Функция ОписаниеПоследнейКассовойСмены(ФискальноеУстройство) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	КассоваяСмена.Ссылка КАК КассоваяСмена,
    |    КассоваяСмена.ФискальноеУстройство КАК ФискальноеУстройство,
    |    КассоваяСмена.НачалоКассовойСмены КАК НачалоКассовойСмены,
    |    КассоваяСмена.ОкончаниеКассовойСмены КАК ОкончаниеКассовойСмены,
	|	ДОБАВИТЬКДАТЕ(КассоваяСмена.НачалоКассовойСмены, ДЕНЬ, 1) КАК ДатаИстеченияСрокаДействия,
    |    КассоваяСмена.Организация КАК Организация,
    |    КассоваяСмена.Статус КАК Статус
	|ИЗ
	|	Документ.КассоваяСмена КАК КассоваяСмена
	|ГДЕ
	|	КассоваяСмена.ФискальноеУстройство = &ФискальноеУстройство
	|	И КассоваяСмена.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
    |    КассоваяСмена.НачалоКассовойСмены УБЫВ,
    |    КассоваяСмена.НомерСменыККТ УБЫВ";
	Запрос.УстановитьПараметр("ФискальноеУстройство", ФискальноеУстройство);
	Результат = Запрос.Выполнить().Выгрузить();
	
	Если Результат.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		СтруктураРезультат = Новый Структура();
		Для Каждого КолонкаРезультата Из Результат.Колонки Цикл
			СтруктураРезультат.Вставить(КолонкаРезультата.Имя, Результат[0][КолонкаРезультата.Имя]);
		КонецЦикла;
		Возврат СтруктураРезультат;
	КонецЕсли;
	
КонецФункции

// Создать новую кассовую смену.
//
// Параметры:
//  ФискальноеУстройство - СправочникСсылка.ПодключаемоеОборудование
//  ПараметрыКоманды - Структура
//
// Возвращаемое значение:
//  ДокументСсылка.КассоваяСмена.
//
Функция НоваяКассоваяСмена(ФискальноеУстройство, ПараметрыКоманды) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	КассоваяСменаОбъект = Документы.КассоваяСмена.СоздатьДокумент();
	КассоваяСменаОбъект.Дата = МенеджерОборудованияВызовСервера.ДатаСеанса();
	КассоваяСменаОбъект.ФискальноеУстройство = ФискальноеУстройство;
	КассоваяСменаОбъект.НачалоКассовойСмены = КассоваяСменаОбъект.Дата;
	КассоваяСменаОбъект.Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ФискальноеУстройство, "Организация");
	КассоваяСменаОбъект.Статус = Перечисления.СтатусыКассовойСмены.Открыта;
	
	Если ПараметрыКоманды <> Неопределено Тогда 
		
		Если ПараметрыКоманды.Свойство("ИдентификаторСмены")
			И ПараметрыКоманды.ИдентификаторСмены <> Неопределено Тогда
			НовыйКассоваяСменаСсылка = Документы.КассоваяСмена.ПолучитьСсылку(ПараметрыКоманды.ИдентификаторСмены);
			КассоваяСменаОбъект.УстановитьСсылкуНового(НовыйКассоваяСменаСсылка);	
		КонецЕсли;
		
		Если ПараметрыКоманды.Свойство("ДополнительныеПараметры")
			И ПараметрыКоманды.ДополнительныеПараметры <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(КассоваяСменаОбъект, ПараметрыКоманды.ДополнительныеПараметры);
		КонецЕсли;
		
		Если ПараметрыКоманды.Свойство("ФискальныеДанныеСтруктура") Тогда
			ЗаполнитьЗначенияСвойств(КассоваяСменаОбъект, ПараметрыКоманды.ФискальныеДанныеСтруктура);
		КонецЕсли;
		
		Если ПараметрыКоманды.Свойство("ФискальныеДанныеXMLСтрока") Тогда
			КассоваяСменаОбъект.ФДОЗакрытииСмены = Новый ХранилищеЗначения(ПараметрыКоманды.ФискальныеДанныеXMLСтрока, Новый СжатиеДанных(9));
		КонецЕсли;
		
	КонецЕсли;
	
	КассоваяСменаОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
	Возврат КассоваяСменаОбъект.Ссылка;
	
КонецФункции

// Закрыть открытую ранее кассовую смену.
//
// Параметры:
//  ПараметрыКоманды - Структура
//
Процедура ЗакрытьКассовуюСмену(ПараметрыКоманды) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	КассоваяСменаОбъект = ПараметрыКоманды.КассоваяСмена.ПолучитьОбъект();
	КассоваяСменаОбъект.Статус = Перечисления.СтатусыКассовойСмены.Закрыта;
	КассоваяСменаОбъект.ОкончаниеКассовойСмены = МенеджерОборудованияВызовСервера.ДатаСеанса();
	
	Если ПараметрыКоманды.Свойство("ФискальныеДанныеСтруктура") Тогда
		ЗаполнитьЗначенияСвойств(КассоваяСменаОбъект, ПараметрыКоманды.ФискальныеДанныеСтруктура);
	КонецЕсли;
	
	Если ПараметрыКоманды.Свойство("ФискальныеДанныеXMLСтрока") Тогда
		КассоваяСменаОбъект.ФДОЗакрытииСмены = Новый ХранилищеЗначения(ПараметрыКоманды.ФискальныеДанныеXMLСтрока, Новый СжатиеДанных(9));
	КонецЕсли;
	
	КассоваяСменаОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
КонецПроцедуры

#КонецОбласти
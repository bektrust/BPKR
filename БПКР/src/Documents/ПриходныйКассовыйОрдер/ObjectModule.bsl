#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ЗаполненияДокумента

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - ДокументСсылка.Доверенность - Данные заполнения документа.
//	
Процедура ЗаполнитьПоДоверенности(ДанныеЗаполнения) Экспорт
	ДокументОснование = ДанныеЗаполнения;
	
	// Реквизиты организации.
	Организация = ДанныеЗаполнения.Организация;
	Касса = Организация.ОсновнаяКасса;	
	ВалютаДокумента = Касса.ВалютаДенежныхСредств;
	
	// Реквизиты контрагента.
	Контрагент = ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента = ДанныеЗаполнения.ДоговорКонтрагента;
	ВалютаРасчетов = ДоговорКонтрагента.ВалютаРасчетов;
	
	ДатаДокумента = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
	КурсСтруктура = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ДатаДокумента);
	Если ЗначениеЗаполнено(КурсСтруктура.Курс) Тогда
		Курс = КурсСтруктура.Курс;
		Кратность = КурсСтруктура.Кратность; 
	Иначе
		Курс = 1;
		Кратность = 1;
	КонецЕсли;		
	
	Если ВалютаРасчетов = ВалютаДокумента Тогда 
		КурсВзаиморасчетов = Курс;
		КратностьВзаиморасчетов = Кратность;
	Иначе 
		КурсСтруктура = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, ДатаДокумента);

		ДанныеДокумента = Новый Структура();
		ДанныеДокумента.Вставить("Валюта" , 	ВалютаДокумента);
		ДанныеДокумента.Вставить("Курс" , 		Курс);
		ДанныеДокумента.Вставить("Кратность" , 	Кратность);
		ДанныеДокумента.Вставить("ПрямойКурс" , Ложь);
		
		ДанныВзаиморасчетов = Новый Структура("Валюта, Курс, Кратность", ВалютаРасчетов, КурсСтруктура.Курс, КурсСтруктура.Кратность);
		УчетДенежныхСредствКлиентСервер.УстановитьКурсыВзаиморасчетов(ЭтотОбъект, ДанныеДокумента, ДанныВзаиморасчетов);
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - ДокументСсылка.РеализацияТоваровУслуг - Данные заполнения документа.
//	
Процедура ЗаполнитьПоРеализацииТоваровУслуг(ДанныеЗаполнения) Экспорт
	ДокументОснование = ДанныеЗаполнения;
	
	// Реквизиты организации.
	Организация = ДанныеЗаполнения.Организация;
	Касса = Организация.ОсновнаяКасса;	
	ВалютаДокумента = Касса.ВалютаДенежныхСредств;
	
	// Реквизиты контрагента.
	Контрагент 	= ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента = ДанныеЗаполнения.ДоговорКонтрагента;
	ВалютаРасчетов = ДоговорКонтрагента.ВалютаРасчетов;
	
	СчетаРасчетовСКонтрагентом = БухгалтерскийУчетСервер.ПолучитьСчетаРасчетовСКонтрагентом(Организация, Контрагент, ДоговорКонтрагента);
	СчетРасчетов = СчетаРасчетовСКонтрагентом.СчетРасчетовПокупателя;
	
	ДатаДокумента = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
	КурсСтруктура = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ДатаДокумента);
	Если ЗначениеЗаполнено(КурсСтруктура.Курс) Тогда
		Курс = КурсСтруктура.Курс;
		Кратность = КурсСтруктура.Кратность; 
	Иначе
		Курс = 1;
		Кратность = 1;
	КонецЕсли;		
	
	СуммаДокумента = ДанныеЗаполнения.Товары.Итог("Всего") + ДанныеЗаполнения.Услуги.Итог("Всего") + ДанныеЗаполнения.ОС.Итог("Всего")
		- ДанныеЗаполнения.Товары.Итог("СуммаСкидки") - ДанныеЗаполнения.Услуги.Итог("СуммаСкидки") - ДанныеЗаполнения.ОС.Итог("СуммаСкидки");

	// Реквизиты печати.
	Приложение = ?(ЗначениеЗаполнено(ДанныеЗаполнения.СерияБланкаСФ), СтрШаблон(НСтр("ru = 'Серия СФ %1 № %2 от %3г.'"),
				ДанныеЗаполнения.СерияБланкаСФ, ДанныеЗаполнения.НомерБланкаСФ, Формат(ДанныеЗаполнения.ДатаСФ, "ДЛФ=D")), "");
				
	ПринятоОт = ДанныеЗаполнения.Контрагент.НаименованиеПолное;

	// Рашифровка платежа.
	РасшифровкаПлатежа.Очистить();
	СтрокаТабличнойЧасти = РасшифровкаПлатежа.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ДанныеЗаполнения);
	
	Если ВалютаРасчетов = ВалютаДокумента Тогда 
		КурсВзаиморасчетов = Курс;
		КратностьВзаиморасчетов = Кратность;
		СтрокаТабличнойЧасти.СуммаПлатежа = СуммаДокумента;
		СтрокаТабличнойЧасти.СуммаВзаиморасчетов = СуммаДокумента;
	Иначе 
		ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
		КурсСтруктура = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, ДатаДокумента);

		ДанныеДокумента = Новый Структура();
		ДанныеДокумента.Вставить("Валюта" , 	ВалютаДокумента);
		ДанныеДокумента.Вставить("Курс" , 		Курс);
		ДанныеДокумента.Вставить("Кратность" , 	Кратность);
		ДанныеДокумента.Вставить("ПрямойКурс" , Ложь);
		
		ДанныВзаиморасчетов = Новый Структура("Валюта, Курс, Кратность", ВалютаРасчетов, КурсСтруктура.Курс, КурсСтруктура.Кратность);
		УчетДенежныхСредствКлиентСервер.УстановитьКурсыВзаиморасчетов(ЭтотОбъект, ДанныеДокумента, ДанныВзаиморасчетов);
			
		СтрокаТабличнойЧасти.СуммаПлатежа = ?(ВалютаДокумента = ВалютаРегламентированногоУчета,
			СуммаДокумента * КурсВзаиморасчетов / КратностьВзаиморасчетов,
			СуммаДокумента * КратностьВзаиморасчетов / КурсВзаиморасчетов);			
			
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуВзаиморасчетовТабличнойЧасти(
			ЭтотОбъект, "РасшифровкаПлатежа", ДанныеДокумента, ДанныВзаиморасчетов, ВалютаРегламентированногоУчета);
	КонецЕсли;
	
	СтрокаТабличнойЧасти.СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоНаименованию("Денежные поступления от покупателей");
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - ДокументСсылка.СчетНаОплатуПокупателю - Данные заполнения документа.
//	
Процедура ЗаполнитьПоСчетуНаОплатуПокупателю(ДанныеЗаполнения) Экспорт
	ДокументОснование = ДанныеЗаполнения;
	
	// Реквизиты организации.
	Организация = ДанныеЗаполнения.Организация;
	Касса = Организация.ОсновнаяКасса;	
	ВалютаДокумента = Касса.ВалютаДенежныхСредств;
	
	// Реквизиты контрагента.
	Контрагент 	= ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента = ДанныеЗаполнения.ДоговорКонтрагента;
	ВалютаРасчетов = ДоговорКонтрагента.ВалютаРасчетов;
	
	СчетаРасчетовСКонтрагентом = БухгалтерскийУчетСервер.ПолучитьСчетаРасчетовСКонтрагентом(Организация, Контрагент, ДоговорКонтрагента);
	СчетРасчетов = СчетаРасчетовСКонтрагентом.СчетРасчетовПокупателя;
	
	ДатаДокумента = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
	КурсСтруктура = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ДатаДокумента);
	Если ЗначениеЗаполнено(КурсСтруктура.Курс) Тогда
		Курс = КурсСтруктура.Курс;
		Кратность = КурсСтруктура.Кратность; 
	Иначе
		Курс = 1;
		Кратность = 1;
	КонецЕсли;		
	
	СуммаДокумента = ДанныеЗаполнения.Товары.Итог("Всего") + ДанныеЗаполнения.Услуги.Итог("Всего");

	// Реквизиты печати.
	ПринятоОт = ДанныеЗаполнения.Контрагент.НаименованиеПолное;
	
	// Рашифровка платежа.
	РасшифровкаПлатежа.Очистить();
	СтрокаТабличнойЧасти = РасшифровкаПлатежа.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ДанныеЗаполнения);
	
	Если ВалютаРасчетов = ВалютаДокумента Тогда 
		КурсВзаиморасчетов = Курс;
		КратностьВзаиморасчетов = Кратность;
		СтрокаТабличнойЧасти.СуммаПлатежа = СуммаДокумента;
		СтрокаТабличнойЧасти.СуммаВзаиморасчетов = СуммаДокумента;
	Иначе 
		ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
		КурсСтруктура = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, ДатаДокумента);

		ДанныеДокумента = Новый Структура();
		ДанныеДокумента.Вставить("Валюта" , 	ВалютаДокумента);
		ДанныеДокумента.Вставить("Курс" , 		Курс);
		ДанныеДокумента.Вставить("Кратность" , 	Кратность);
		ДанныеДокумента.Вставить("ПрямойКурс" , Ложь);
		
		ДанныВзаиморасчетов = Новый Структура("Валюта, Курс, Кратность", ВалютаРасчетов, КурсСтруктура.Курс, КурсСтруктура.Кратность);
		УчетДенежныхСредствКлиентСервер.УстановитьКурсыВзаиморасчетов(ЭтотОбъект, ДанныеДокумента, ДанныВзаиморасчетов);
			
		СтрокаТабличнойЧасти.СуммаПлатежа = ?(ВалютаДокумента = ВалютаРегламентированногоУчета,
			СуммаДокумента * КурсВзаиморасчетов / КратностьВзаиморасчетов,
			СуммаДокумента * КратностьВзаиморасчетов / КурсВзаиморасчетов);			
			
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуВзаиморасчетовТабличнойЧасти(
			ЭтотОбъект, "РасшифровкаПлатежа", ДанныеДокумента, ДанныВзаиморасчетов, ВалютаРегламентированногоУчета);
	КонецЕсли;
	
	СтрокаТабличнойЧасти.СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоНаименованию("Денежные поступления от покупателей");
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - ДокументСсылка.ВозвратТоваровПоставщику - Данные заполнения документа.
//	
Процедура ЗаполнитьПоВозвратуТоваровПоставщику(ДанныеЗаполнения) Экспорт
	ДокументОснование = ДанныеЗаполнения;
	
	// Реквизиты организации.
	Организация = ДанныеЗаполнения.Организация;
	Касса = Организация.ОсновнаяКасса;	
	ВалютаДокумента = Касса.ВалютаДенежныхСредств;
	
	// Реквизиты контрагента.
	Контрагент 	= ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента = ДанныеЗаполнения.ДоговорКонтрагента;
	ВалютаРасчетов = ДоговорКонтрагента.ВалютаРасчетов;
	
	СчетаРасчетовСКонтрагентом = БухгалтерскийУчетСервер.ПолучитьСчетаРасчетовСКонтрагентом(Организация, Контрагент, ДоговорКонтрагента);
	СчетРасчетов = СчетаРасчетовСКонтрагентом.СчетРасчетовПокупателя;
	
	ДатаДокумента = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
	КурсСтруктура = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ДатаДокумента);
	Если ЗначениеЗаполнено(КурсСтруктура.Курс) Тогда
		Курс = КурсСтруктура.Курс;
		Кратность = КурсСтруктура.Кратность; 
	Иначе
		Курс = 1;
		Кратность = 1;
	КонецЕсли;		
	
	СуммаДокумента = ДанныеЗаполнения.Товары.Итог("Всего");

	// Реквизиты печати.
	Приложение = ?(ЗначениеЗаполнено(ДанныеЗаполнения.СерияБланкаСФ), СтрШаблон(НСтр("ru = 'Серия СФ %1 № %2 от %3г.'"),
				ДанныеЗаполнения.СерияБланкаСФ, ДанныеЗаполнения.НомерБланкаСФ, Формат(ДанныеЗаполнения.ДатаСФ, "ДЛФ=D")), "");
				
	ПринятоОт = ДанныеЗаполнения.Контрагент.НаименованиеПолное;

	// Рашифровка платежа.
	РасшифровкаПлатежа.Очистить();
	СтрокаТабличнойЧасти = РасшифровкаПлатежа.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ДанныеЗаполнения);
	
	Если ВалютаРасчетов = ВалютаДокумента Тогда 
		КурсВзаиморасчетов = Курс;
		КратностьВзаиморасчетов = Кратность;
		СтрокаТабличнойЧасти.СуммаПлатежа = СуммаДокумента;
		СтрокаТабличнойЧасти.СуммаВзаиморасчетов = СуммаДокумента;
	Иначе 
		ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
		КурсСтруктура = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, ДатаДокумента);

		ДанныеДокумента = Новый Структура();
		ДанныеДокумента.Вставить("Валюта" , 	ВалютаДокумента);
		ДанныеДокумента.Вставить("Курс" , 		Курс);
		ДанныеДокумента.Вставить("Кратность" , 	Кратность);
		ДанныеДокумента.Вставить("ПрямойКурс" , Ложь);
		
		ДанныВзаиморасчетов = Новый Структура("Валюта, Курс, Кратность", ВалютаРасчетов, КурсСтруктура.Курс, КурсСтруктура.Кратность);
		УчетДенежныхСредствКлиентСервер.УстановитьКурсыВзаиморасчетов(ЭтотОбъект, ДанныеДокумента, ДанныВзаиморасчетов);
			
		СтрокаТабличнойЧасти.СуммаПлатежа = ?(ВалютаДокумента = ВалютаРегламентированногоУчета,
			СуммаДокумента * КурсВзаиморасчетов / КратностьВзаиморасчетов,
			СуммаДокумента * КратностьВзаиморасчетов / КурсВзаиморасчетов);			
			
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуВзаиморасчетовТабличнойЧасти(
			ЭтотОбъект, "РасшифровкаПлатежа", ДанныеДокумента, ДанныВзаиморасчетов, ВалютаРегламентированногоУчета);
	КонецЕсли;
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - ДокументСсылка.РасходныйКассовыйОрдер - Данные заполнения документа.
//	
Процедура ЗаполнитьРасходномуКассовомуОрдеру(ДанныеЗаполнения) Экспорт
	ДокументОснование = ДанныеЗаполнения;
	
	// Шапка.
	ВидОперации = Перечисления.ВидыОперацийПКО.Конвертация;
	СчетРасчетов = ПланыСчетов.Хозрасчетный.ДенежныеСредстваВПути;
	
	// Реквизиты организации.
	Организация = ДанныеЗаполнения.Организация;
	Касса = ДанныеЗаполнения.Касса;
	ВалютаДокумента = Касса.ВалютаДенежныхСредств;
	
	// Реквизиты контрагента.
	КурсВзаиморасчетов = ДанныеЗаполнения.КурсВзаиморасчетов;
	КратностьВзаиморасчетов = ДанныеЗаполнения.КратностьВзаиморасчетов;
	ВалютаРасчетов = ДанныеЗаполнения.ВалютаДокумента;
	
	ДатаДокумента = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
	КурсСтруктура = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ДатаДокумента);
	Если ЗначениеЗаполнено(КурсСтруктура.Курс) Тогда
		Курс = КурсСтруктура.Курс;
		Кратность = КурсСтруктура.Кратность; 
	Иначе
		Курс = 1;
		Кратность = 1;
	КонецЕсли;
	
	Если ДанныеЗаполнения.ПрочиеПлатежи.Количество() > 0 Тогда
		Если (ДанныеЗаполнения.ВидОперации = Перечисления.ВидыОперацийРКО.ПрочийРасход 
			И ДанныеЗаполнения.ПрочиеПлатежи[0].СчетРасчетов = ПланыСчетов.Хозрасчетный.ДенежныеСредстваВПути)
			ИЛИ ДанныеЗаполнения.ВидОперации = Перечисления.ВидыОперацийРКО.Инкассация Тогда
			ВидОперации = Перечисления.ВидыОперацийПКО.Конвертация;
			Комментарий = НСтр("ru = 'Конвертация'");
			
			СуммаДокумента = ДанныеЗаполнения.ПрочиеПлатежи.Итог("СуммаПлатежа");		
		КонецЕсли;
	ИначеЕсли ДанныеЗаполнения.РасшифровкаПлатежа.Количество() > 0 
		И ДанныеЗаполнения.ВидОперации = Перечисления.ВидыОперацийРКО.Инкассация Тогда
		ВидОперации = Перечисления.ВидыОперацийПКО.Конвертация;
		Комментарий = НСтр("ru = 'Конвертация'");
		
		СуммаДокумента = ДанныеЗаполнения.РасшифровкаПлатежа.Итог("СуммаВзаиморасчетов");
		
	КонецЕсли;
	
	СтрокаТабличнойЧасти = РасшифровкаПлатежа.Добавить();
	
	Если ВалютаРасчетов = ВалютаДокумента Тогда 
		КурсВзаиморасчетов = Курс;
		КратностьВзаиморасчетов = Кратность;
		СтрокаТабличнойЧасти.СуммаПлатежа = СуммаДокумента;
		СтрокаТабличнойЧасти.СуммаВзаиморасчетов = СуммаДокумента;
	Иначе 
		ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
		КурсСтруктура = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, ДатаДокумента);
		
		ДанныеДокумента = Новый Структура();
		ДанныеДокумента.Вставить("Валюта" , 	ВалютаДокумента);
		ДанныеДокумента.Вставить("Курс" , 		Курс);
		ДанныеДокумента.Вставить("Кратность" , 	Кратность);
		ДанныеДокумента.Вставить("ПрямойКурс" , Ложь);
		
		ДанныВзаиморасчетов = Новый Структура("Валюта, Курс, Кратность", ВалютаРасчетов, КурсСтруктура.Курс, КурсСтруктура.Кратность);
		УчетДенежныхСредствКлиентСервер.УстановитьКурсыВзаиморасчетов(ЭтотОбъект, ДанныеДокумента, ДанныВзаиморасчетов);
		
		СтрокаТабличнойЧасти.СуммаПлатежа = ?(ВалютаДокумента = ВалютаРегламентированногоУчета,
		СуммаДокумента * КурсВзаиморасчетов / КратностьВзаиморасчетов,
		СуммаДокумента * КратностьВзаиморасчетов / КурсВзаиморасчетов);			
		
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуВзаиморасчетовТабличнойЧасти(
		ЭтотОбъект, "РасшифровкаПлатежа", ДанныеДокумента, ДанныВзаиморасчетов, ВалютаРегламентированногоУчета);
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - ДокументСсылка.ЗаказНаПроизводство - Данные заполнения документа.
//	
Процедура ЗаполнитьПоЗаказуНаПроизводство(ДанныеЗаполнения) Экспорт
	ДокументОснование = ДанныеЗаполнения;
	
	// Шапка.
	ВидОперации = Перечисления.ВидыОперацийПКО.ОплатаОтПокупателя;

	// Реквизиты организации.
	Организация = ДанныеЗаполнения.Организация;
	Касса = Организация.ОсновнаяКасса;
	ВалютаДокумента = Касса.ВалютаДенежныхСредств;
	
	// Реквизиты контрагента.
	Контрагент 	= ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента = ДанныеЗаполнения.ДоговорКонтрагента;
	ВалютаРасчетов = ДоговорКонтрагента.ВалютаРасчетов;
	
	СчетРасчетов = БухгалтерскийУчетВызовСервера.ПолучитьСчетаРасчетовСКонтрагентом(Организация, Контрагент, ДоговорКонтрагента).СчетАвансовПокупателя;
	
	ВалютаРасчетовКурсКратность = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, ДокументОснование.Дата);
	КурсВзаиморасчетов = ?(ВалютаРасчетовКурсКратность.Курс = 0, 1, ВалютаРасчетовКурсКратность.Курс);
	КратностьВзаиморасчетов = ?(ВалютаРасчетовКурсКратность.Кратность = 0, 1, ВалютаРасчетовКурсКратность.Кратность);	
	
	Если ДанныеЗаполнения.Продукция.Количество() > 0 Тогда			
			СтрокаТабличнойЧасти = РасшифровкаПлатежа.Добавить();
			
			СтрокаТабличнойЧасти.СуммаВзаиморасчетов = ДанныеЗаполнения.Продукция.Итог("Сумма") - ДанныеЗаполнения.Продукция.Итог("СуммаСкидки");
			СтрокаТабличнойЧасти.СуммаПлатежа = СтрокаТабличнойЧасти.СуммаВзаиморасчетов * КурсВзаиморасчетов / КратностьВзаиморасчетов;	
	КонецЕсли;	
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - ДокументСсылка.ОтчетОРозничныхПродажах - Данные заполнения документа.
//	
Процедура ЗаполнитьПоОтчетОРозничныхПродажах(ДанныеЗаполнения) Экспорт
	ДокументОснование = ДанныеЗаполнения;
	
	ВидОперации = Перечисления.ВидыОперацийПКО.РозничнаяВыручка;
	
	// Реквизиты организации.
	Организация = ДанныеЗаполнения.Организация;
	Касса = ДанныеЗаполнения.Касса;	
	ВалютаДокумента = Касса.ВалютаДенежныхСредств;
	
	// Реквизиты контрагента.
	Контрагент 	= ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента = ДанныеЗаполнения.ДоговорКонтрагента;
	ВалютаРасчетов = ДоговорКонтрагента.ВалютаРасчетов;
	
	СчетРасчетов = ДанныеЗаполнения.СчетРасчетовКт;
	
	ДатаДокумента = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
	КурсСтруктура = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ДатаДокумента);
	Если ЗначениеЗаполнено(КурсСтруктура.Курс) Тогда
		Курс = КурсСтруктура.Курс;
		Кратность = КурсСтруктура.Кратность; 
	Иначе
		Курс = 1;
		Кратность = 1;
	КонецЕсли;		
	
	ИтогСуммаБезналичные = ДанныеЗаполнения.Оплата.Итог("СуммаОплаты") - ДанныеЗаполнения.ВозвратОплаты.Итог("СуммаОплаты");
	СуммаДокумента = ДанныеЗаполнения.Товары.Итог("Всего") 
		+ ДанныеЗаполнения.Услуги.Итог("Всего") 
		+ ДанныеЗаполнения.ПодарочныеСертификаты.Итог("Сумма")
		- ИтогСуммаБезналичные 
		- ДанныеЗаполнения.Возвраты.Итог("Всего") 
		- ДанныеЗаполнения.ВозвратУслуг.Итог("Всего");
				
	ПринятоОт = ДанныеЗаполнения.Контрагент.НаименованиеПолное;

	// Рашифровка платежа.
	РасшифровкаПлатежа.Очистить();
	СтрокаТабличнойЧасти = РасшифровкаПлатежа.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ДанныеЗаполнения);
	
	Если ВалютаРасчетов = ВалютаДокумента Тогда 
		КурсВзаиморасчетов = Курс;
		КратностьВзаиморасчетов = Кратность;
		СтрокаТабличнойЧасти.СуммаПлатежа = СуммаДокумента;
		СтрокаТабличнойЧасти.СуммаВзаиморасчетов = СуммаДокумента;
		СтрокаТабличнойЧасти.СтатьяДвиженияДенежныхСредств = ДанныеЗаполнения.СтатьяДвиженияДенежныхСредств;
	Иначе 
		ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
		КурсСтруктура = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, ДатаДокумента);

		ДанныеДокумента = Новый Структура();
		ДанныеДокумента.Вставить("Валюта" , 	ВалютаДокумента);
		ДанныеДокумента.Вставить("Курс" , 		Курс);
		ДанныеДокумента.Вставить("Кратность" , 	Кратность);
		ДанныеДокумента.Вставить("ПрямойКурс" , Ложь);
		
		ДанныВзаиморасчетов = Новый Структура("Валюта, Курс, Кратность", ВалютаРасчетов, КурсСтруктура.Курс, КурсСтруктура.Кратность);
		УчетДенежныхСредствКлиентСервер.УстановитьКурсыВзаиморасчетов(ЭтотОбъект, ДанныеДокумента, ДанныВзаиморасчетов);
			
		СтрокаТабличнойЧасти.СуммаПлатежа = ?(ВалютаДокумента = ВалютаРегламентированногоУчета,
			СуммаДокумента * КурсВзаиморасчетов / КратностьВзаиморасчетов,
			СуммаДокумента * КратностьВзаиморасчетов / КурсВзаиморасчетов);			
			
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуВзаиморасчетовТабличнойЧасти(
			ЭтотОбъект, "РасшифровкаПлатежа", ДанныеДокумента, ДанныВзаиморасчетов, ВалютаРегламентированногоУчета);
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - ДокументСсылка.РеализацияТоваровУслуг - Данные заполнения документа.
//	
Процедура ЗаполнитьПоКорректировкеСтоимостиРеализации(ДанныеЗаполнения) Экспорт
	ДокументОснование = ДанныеЗаполнения;
	
	ВидОперации = Перечисления.ВидыОперацийПКО.ОплатаОтПокупателя;
	
	// Реквизиты организации.
	Организация = ДанныеЗаполнения.Организация;
	Касса = Организация.ОсновнаяКасса;	
	ВалютаДокумента = Касса.ВалютаДенежныхСредств;
	
	// Реквизиты контрагента.
	Контрагент 	= ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента = ДанныеЗаполнения.ДоговорКонтрагента;
	ВалютаРасчетов = ДоговорКонтрагента.ВалютаРасчетов;
	
	СчетаРасчетовСКонтрагентом = БухгалтерскийУчетСервер.ПолучитьСчетаРасчетовСКонтрагентом(Организация, Контрагент, ДоговорКонтрагента);
	СчетРасчетов = СчетаРасчетовСКонтрагентом.СчетРасчетовПокупателя;
	
	ДатаДокумента = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
	КурсСтруктура = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ДатаДокумента);
	Если ЗначениеЗаполнено(КурсСтруктура.Курс) Тогда
		Курс = КурсСтруктура.Курс;
		Кратность = КурсСтруктура.Кратность; 
	Иначе
		Курс = 1;
		Кратность = 1;
	КонецЕсли;		
	
	СуммаДокумента = 0;
	
	Если НЕ ДанныеЗаполнения.БезналичныйРасчет Тогда
		ТабличныеЧасти = Новый Массив();
		ТабличныеЧасти.Добавить(ДанныеЗаполнения.Товары);
		ТабличныеЧасти.Добавить(ДанныеЗаполнения.Услуги);
		ТабличныеЧасти.Добавить(ДанныеЗаполнения.ОС);
		
		Для Каждого ТабличнаяЧасть Из ТабличныеЧасти Цикл
			
			Для Каждого СтрокаТабличнойЧасти Из ТабличнаяЧасть Цикл	
				
				Если СтрокаТабличнойЧасти.Всего > 0 Тогда
					СуммаДокумента = СуммаДокумента + СтрокаТабличнойЧасти.Всего;	
				КонецЕсли;	
			КонецЦикла;
		КонецЦикла;	
	КонецЕсли;
		
	// Реквизиты печати.		
	ПринятоОт = ДанныеЗаполнения.Контрагент.НаименованиеПолное;

	// Рашифровка платежа.
	РасшифровкаПлатежа.Очистить();
	СтрокаТабличнойЧасти = РасшифровкаПлатежа.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ДанныеЗаполнения);
	
	Если ВалютаРасчетов = ВалютаДокумента Тогда 
		КурсВзаиморасчетов = Курс;
		КратностьВзаиморасчетов = Кратность;
		СтрокаТабличнойЧасти.СуммаПлатежа = СуммаДокумента;
		СтрокаТабличнойЧасти.СуммаВзаиморасчетов = СуммаДокумента;
	Иначе 
		ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
		КурсСтруктура = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, ДатаДокумента);

		ДанныеДокумента = Новый Структура();
		ДанныеДокумента.Вставить("Валюта" , 	ВалютаДокумента);
		ДанныеДокумента.Вставить("Курс" , 		Курс);
		ДанныеДокумента.Вставить("Кратность" , 	Кратность);
		ДанныеДокумента.Вставить("ПрямойКурс" , Ложь);
		
		ДанныВзаиморасчетов = Новый Структура("Валюта, Курс, Кратность", ВалютаРасчетов, КурсСтруктура.Курс, КурсСтруктура.Кратность);
		УчетДенежныхСредствКлиентСервер.УстановитьКурсыВзаиморасчетов(ЭтотОбъект, ДанныеДокумента, ДанныВзаиморасчетов);
			
		СтрокаТабличнойЧасти.СуммаПлатежа = ?(ВалютаДокумента = ВалютаРегламентированногоУчета,
			СуммаДокумента * КурсВзаиморасчетов / КратностьВзаиморасчетов,
			СуммаДокумента * КратностьВзаиморасчетов / КурсВзаиморасчетов);			
			
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуВзаиморасчетовТабличнойЧасти(
			ЭтотОбъект, "РасшифровкаПлатежа", ДанныеДокумента, ДанныВзаиморасчетов, ВалютаРегламентированногоУчета);
	КонецЕсли;
	
	СтрокаТабличнойЧасти.СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоНаименованию("Денежные поступления от покупателей");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.Доверенность")] = "ЗаполнитьПоДоверенности";
	СтратегияЗаполнения[Тип("ДокументСсылка.РеализацияТоваровУслуг")] = "ЗаполнитьПоРеализацииТоваровУслуг";
	СтратегияЗаполнения[Тип("ДокументСсылка.СчетНаОплатуПокупателю")] = "ЗаполнитьПоСчетуНаОплатуПокупателю";
	СтратегияЗаполнения[Тип("ДокументСсылка.ВозвратТоваровПоставщику")] = "ЗаполнитьПоВозвратуТоваровПоставщику";
	СтратегияЗаполнения[Тип("ДокументСсылка.РасходныйКассовыйОрдер")] = "ЗаполнитьРасходномуКассовомуОрдеру";
	СтратегияЗаполнения[Тип("ДокументСсылка.ЗаказНаПроизводство")] = "ЗаполнитьПоЗаказуНаПроизводство";
	СтратегияЗаполнения[Тип("ДокументСсылка.ОтчетОРозничныхПродажах")] = "ЗаполнитьПоОтчетОРозничныхПродажах";
	СтратегияЗаполнения[Тип("ДокументСсылка.КорректировкаСтоимостиРеализации")] = "ЗаполнитьПоКорректировкеСтоимостиРеализации";

	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
	Если ЗначениеЗаполнено(Касса)
		И НЕ ЗначениеЗаполнено(ВалютаДокумента) Тогда
		ВалютаДокумента = Касса.ВалютаДенежныхСредств;
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(КурсВзаиморасчетов)  
		ИЛИ НЕ ЗначениеЗаполнено(КратностьВзаиморасчетов) Тогда 
		
		КурсВзаиморасчетов = 1;
		КратностьВзаиморасчетов = 1;
	КонецЕсли;	
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Добавить("РасшифровкаПлатежа");

	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ВидОперации = Перечисления.ВидыОперацийПКО.ПрочийПриход Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("СчетРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("БанковскийСчет");
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицо");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СуммаПлатежа"); 
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СуммаВзаиморасчетов");
		
		ПроверяемыеРеквизиты.Добавить("ПрочиеПлатежи");
		
		// Контроль заполнения субконто Договор.
		ОписаниеТиповДоговор = Новый ОписаниеТипов("СправочникСсылка.ДоговорыКонтрагентов");
		Для Каждого СтрокаТабличнойЧасти Из ПрочиеПлатежи Цикл
			
			СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТабличнойЧасти.СчетРасчетов);
			Если СвойстваСчета.ВидСубконто1ТипЗначения = ОписаниеТиповДоговор
					И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Субконто1)
				Или СвойстваСчета.ВидСубконто2ТипЗначения = ОписаниеТиповДоговор
					И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Субконто2)	
				Или СвойстваСчета.ВидСубконто3ТипЗначения = ОписаниеТиповДоговор
					И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Субконто3) Тогда 
					
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("КОЛОНКА",, НСтр("ru = 'Субконто'"), СтрокаТабличнойЧасти.НомерСтроки, "Прочие платежи");
				ПолеСообщения = СтрШаблон("Объект.ПрочиеПлатежи[%1].Субконто2", СтрокаТабличнойЧасти.НомерСтроки-1);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, ПолеСообщения,, Отказ);
			
			// Валюта документа и договора должны быть одинаковы.
			ИначеЕсли СвойстваСчета.ВидСубконто1ТипЗначения = ОписаниеТиповДоговор
					И НЕ СтрокаТабличнойЧасти.Субконто1.ВалютаРасчетов = ВалютаДокумента
				Или СвойстваСчета.ВидСубконто2ТипЗначения = ОписаниеТиповДоговор
					И НЕ СтрокаТабличнойЧасти.Субконто2.ВалютаРасчетов = ВалютаДокумента	
				Или СвойстваСчета.ВидСубконто3ТипЗначения = ОписаниеТиповДоговор
					И НЕ СтрокаТабличнойЧасти.Субконто3.ВалютаРасчетов = ВалютаДокумента Тогда 	
			
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("КОЛОНКА", 
					"КОРРЕКТНОСТЬ", 
					НСтр("ru = 'Субконто'"), 
					СтрокаТабличнойЧасти.НомерСтроки, 
					"Прочие платежи",
					НСтр("ru = 'Валюта договора должна совпадать с валютой документа.'"));
				ПолеСообщения = СтрШаблон("Объект.ПрочиеПлатежи[%1].Субконто2", СтрокаТабличнойЧасти.НомерСтроки-1);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, ПолеСообщения,, Отказ);		
			КонецЕсли;	
		КонецЦикла;
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПКО.ОплатаОтПокупателя
		Или ВидОперации = Перечисления.ВидыОперацийПКО.ВозвратОтПоставщика
		Или ВидОперации = Перечисления.ВидыОперацийПКО.РасчетыПоЗаймам
		Или ВидОперации = Перечисления.ВидыОперацийПКО.РозничнаяВыручка Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицо");
		МассивНепроверяемыхРеквизитов.Добавить("БанковскийСчет");
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПКО.ВозвратОтСотрудника Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("СчетРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("БанковскийСчет");
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПКО.ВозвратОтПодотчетника Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("БанковскийСчет");
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПКО.ПолучениеНаличныхВБанке Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
		МассивНепроверяемыхРеквизитов.Добавить("СчетРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицо");

	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПКО.Конвертация Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
		МассивНепроверяемыхРеквизитов.Добавить("БанковскийСчет");
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицо");		
	КонецЕсли;
	
	// Вид деятельности.
	ВидыОперацийЕдиныйНалог = ОбщегоНазначенияБПСервер.ВидыОперацийЕдиныйНалог();
	Если ВидыОперацийЕдиныйНалог.Найти(ВидОперации) = Неопределено Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.ВидДеятельности");
	КонецЕсли;	
	
	ОбщегоНазначенияБПСервер.ДобавитьНепроверяемыеРеквизитыПоПараметрамФункциональныхОпций(МассивНепроверяемыхРеквизитов, Организация, Дата);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
КонецПроцедуры

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийПКО.ПрочийПриход
		И НЕ РасшифровкаПлатежа.Количество() = 0 Тогда 
		РасшифровкаПлатежа.Очистить();
	ИначеЕсли НЕ ВидОперации = Перечисления.ВидыОперацийПКО.ПрочийПриход
		И НЕ ПрочиеПлатежи.Количество() = 0 Тогда
		ПрочиеПлатежи.Очистить();
	КонецЕсли;
	
	СуммаДокумента = РасшифровкаПлатежа.Итог("СуммаПлатежа") + ПрочиеПлатежи.Итог("СуммаПлатежа");
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ИнициализироватьДанные(Отказ, РежимПроведения);
	
	ОтразитьДвижения(Отказ, РежимПроведения);
	
	// Запись наборов записей.
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
КонецПроцедуры // ОбработкаУдаленияПроведения()

// Процедура - обработчик события ПриУстановкеНовогоНомера объекта.
//
Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	Если ЗначениеЗаполнено(Префикс) Тогда 
		Возврат;
	КонецЕсли;

	Если ПолучитьФункциональнуюОпцию("ИспользоватьПрефиксКассыИБанковскогоСчета") Тогда
		Префикс = ?(Касса.Префикс = "", "0", Касса.Префикс);
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииОбработкаПроведения

// Процедура инициализирует данные документа
// и подготавливает таблицы для движения в регистры
//
Процедура ИнициализироватьДанные(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ПриходныйКассовыйОрдер.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
КонецПроцедуры
	
// Процедура заполняет регистры данными
//
Процедура ОтразитьДвижения(Отказ, РежимПроведения)

	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьХозрасчетный(ДополнительныеСвойства, Движения, Отказ);
	
	ЭтоКонвертация = ВидОперации = Перечисления.ВидыОперацийПКО.Конвертация;
	УчетДенежныхСредств.СформироватьДвиженияОперационнаяКурсоваяРазница(ДополнительныеСвойства, Движения, Отказ, Истина, ЭтоКонвертация);
	
	БухгалтерскийУчетСервер.ОтразитьВозвратПодотчетником(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьАвансыПодотчетника(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьВыплаченнаяЗарплата(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьОборотыПоДаннымЕдиногоНалога(ДополнительныеСвойства, Движения, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		
#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);

	Если Не ЗначениеЗаполнено(ДатаНачала) Тогда 
		ДатаНачала 	 = НачалоКвартала(Дата);
		ДатаОкончания = КонецКвартала(Дата);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет табличную часть
//
Процедура ЗаполнитьТабличнуюЧастьОтчет() Экспорт
	
	// Квартальный отчет формируется только по сотрудникам,
	// на которых оформлен документ "Трудовое соглашение" (внештатные).
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ХозрасчетныйОборотыДтКт.СубконтоКт1 КАК ФизЛицо,
		|	ХозрасчетныйОборотыДтКт.Организация КАК Организация,
		|	ХозрасчетныйОборотыДтКт.СуммаОборот КАК СуммаПН
		|ПОМЕСТИТЬ ВременнаяТаблицаПрочиеФизЛица
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(&НачалоПериода, &КонецПериода, , , , СчетКт = &СчетУчетаПоПНДляПрочихФизическихЛиц, ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.СотрудникиОрганизаций), Организация = &Организация) КАК ХозрасчетныйОборотыДтКт
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СотрудникиПоТрудовымСоглашениямСрезПоследних.ФизЛицо КАК ФизЛицо
		|ПОМЕСТИТЬ ВременнаяТаблицаСотрудникиПоТрудовымСоглашениям
		|ИЗ
		|	РегистрСведений.СотрудникиПоТрудовымСоглашениям.СрезПоследних(&НачалоПериода, Организация = &Организация) КАК СотрудникиПоТрудовымСоглашениямСрезПоследних
		|ГДЕ
		|	НЕ СотрудникиПоТрудовымСоглашениямСрезПоследних.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СотрудникиПоТрудовымСоглашениям.ФизЛицо
		|ИЗ
		|	РегистрСведений.СотрудникиПоТрудовымСоглашениям КАК СотрудникиПоТрудовымСоглашениям
		|ГДЕ
		|	СотрудникиПоТрудовымСоглашениям.Период МЕЖДУ &НачалоПериода И &КонецПериода
		|	И СотрудникиПоТрудовымСоглашениям.Организация = &Организация
		|	И СотрудникиПоТрудовымСоглашениям.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Прием)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаПрочиеФизЛица.ФизЛицо
		|ИЗ
		|	ВременнаяТаблицаПрочиеФизЛица КАК ВременнаяТаблицаПрочиеФизЛица
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ФизЛицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПодоходныйНалогОбороты.ФизЛицо КАК ФизЛицо,
		|	ВЫБОР
		|		КОГДА ПодоходныйНалогОбороты.ОДПНОборот = 0
		|			ТОГДА 0
		|		ИНАЧЕ ПодоходныйНалогОбороты.ОДПНОборот - ПодоходныйНалогОбороты.ПФРДляРасчетаПНОборот - ПодоходныйНалогОбороты.ГНПФРДляРасчетаПНОборот - ПодоходныйНалогОбороты.ВычетыОборот * 100
		|	КОНЕЦ КАК ОДПН,
		|	ПодоходныйНалогОбороты.ПНОборот КАК СуммаПН
		|ПОМЕСТИТЬ ВременнаяТаблицаПН
		|ИЗ
		|	РегистрНакопления.ПодоходныйНалог.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			,
		|			Организация = &Организация
		|				И ФизЛицо В
		|					(ВЫБРАТЬ
		|						ВременнаяТаблицаСотрудникиПоТрудовымСоглашениям.ФизЛицо КАК ФизЛицо
		|					ИЗ
		|						ВременнаяТаблицаСотрудникиПоТрудовымСоглашениям КАК ВременнаяТаблицаСотрудникиПоТрудовымСоглашениям)) КАК ПодоходныйНалогОбороты
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаПрочиеФизЛица.ФизЛицо,
		|	ВременнаяТаблицаПрочиеФизЛица.СуммаПН * 10,
		|	ВременнаяТаблицаПрочиеФизЛица.СуммаПН
		|ИЗ
		|	ВременнаяТаблицаПрочиеФизЛица КАК ВременнаяТаблицаПрочиеФизЛица
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ФизЛицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ГражданствоФизическихЛицСрезПоследних.ФизЛицо КАК Физлицо,
		|	ГражданствоФизическихЛицСрезПоследних.Страна КАК Страна
		|ПОМЕСТИТЬ ВременнаяТаблицаГражданство
		|ИЗ
		|	РегистрСведений.ГражданствоФизическихЛиц.СрезПоследних(
		|			&КонецПериода,
		|			ФизЛицо В
		|				(ВЫБРАТЬ
		|					ВременнаяТаблицаПН.ФизЛицо
		|				ИЗ
		|					ВременнаяТаблицаПН КАК ВременнаяТаблицаПН)) КАК ГражданствоФизическихЛицСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаПН.ФизЛицо КАК Физлицо,
		|	""001"" КАК КодДохода,
		|	ВременнаяТаблицаПН.ОДПН КАК ОДПН,
		|	ВременнаяТаблицаПН.СуммаПН КАК СуммаПН,
		|	ЕСТЬNULL(ВременнаяТаблицаГражданство.Страна.Код, """") КАК КодСтраны,
		|	ВременнаяТаблицаПН.ФизЛицо.ИНН КАК НомерНалоговойРегистрации
		|ИЗ
		|	ВременнаяТаблицаПН КАК ВременнаяТаблицаПН
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаГражданство КАК ВременнаяТаблицаГражданство
		|		ПО ВременнаяТаблицаПН.ФизЛицо = ВременнаяТаблицаГражданство.Физлицо";
	Запрос.УстановитьПараметр("НачалоПериода", ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ДатаОкончания));
	Запрос.УстановитьПараметр("Организация", Организация);
	
	СчетУчетаПоПНДляПрочихФизическихЛиц = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьДанныеУчетнойПолитикиПоПерсоналу(Дата, Организация).СчетУчетаПоПНДляПрочихФизическихЛиц;
	Запрос.УстановитьПараметр("СчетУчетаПоПНДляПрочихФизическихЛиц", СчетУчетаПоПНДляПрочихФизическихЛиц);
	
	Отчет.Загрузить(Запрос.Выполнить().Выгрузить());
			
КонецПроцедуры // ЗаполнитьТабличнуюЧастьОтчет()

// Процедура заполняет табличную часть
//
Процедура ЗаполнитьТабличнуюЧастьОтчетГодовой() Экспорт
	
	// Годовой отчет формируется только по сотрудникам,
	// на которых оформлен документ "Прием на работу" (штатные).
	Запрос = Новый Запрос;   
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СотрудникиСрезПоследних.ФизЛицо КАК ФизЛицо
		|ПОМЕСТИТЬ ВременнаяТаблицаСотрудники
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(&НачалоПериода, Организация = &Организация) КАК СотрудникиСрезПоследних
		|ГДЕ
		|	НЕ СотрудникиСрезПоследних.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Сотрудники.ФизЛицо
		|ИЗ
		|	РегистрСведений.Сотрудники КАК Сотрудники
		|ГДЕ
		|	Сотрудники.Период МЕЖДУ &НачалоПериода И &КонецПериода
		|	И Сотрудники.Организация = &Организация
		|	И Сотрудники.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Прием)
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ФизЛицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйОбороты.СубконтоДт1 КАК ФизЛицо,
		|	ХозрасчетныйОбороты.СуммаОборот КАК ВсегоВыплаченноДохода
		|ПОМЕСТИТЬ ВременнаяТаблицаДоходы
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			,
		|			СчетДт = &Счет3520,
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.СотрудникиОрганизаций),
		|			СчетКт В ИЕРАРХИИ (&Счет1100)
		|				ИЛИ СчетКт В ИЕРАРХИИ (&Счет1200)
		|				ИЛИ СчетКт = &Счет1520,
		|			,
		|			Организация = &Организация
		|				И СубконтоДт1 В
		|					(ВЫБРАТЬ
		|						ВременнаяТаблицаСотрудники.ФизЛицо КАК ФизЛицо
		|					ИЗ
		|						ВременнаяТаблицаСотрудники КАК ВременнаяТаблицаСотрудники)) КАК ХозрасчетныйОбороты
		|ГДЕ
		|	НЕ &ЗаполнятьВыплатуПНПоНачислениям
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПодоходныйНалогОбороты.ФизЛицо КАК Физлицо,
		|	ВЫБОР
		|		КОГДА ПодоходныйНалогОбороты.ОДПНОборот = 0
		|			ТОГДА 0
		|		ИНАЧЕ ПодоходныйНалогОбороты.ОДПНОборот - ПодоходныйНалогОбороты.ПФРДляРасчетаПНОборот - ПодоходныйНалогОбороты.ГНПФРДляРасчетаПНОборот - ПодоходныйНалогОбороты.ВычетыОборот * 100
		|	КОНЕЦ КАК ОДПН,
		|	ПодоходныйНалогОбороты.ПНОборот КАК СуммаПН,
		|	ПодоходныйНалогОбороты.ФизЛицо.ИНН КАК ИНН,
		|	""001"" КАК КодДохода,
		|	0 КАК СуммаМатериальнойВыгоды,
		|	0 КАК СуммаПНСМатериальнойВыгоды,
		|	ВЫБОР
		|		КОГДА &ЗаполнятьВыплатуПНПоНачислениям
		|			ТОГДА ПодоходныйНалогОбороты.ВсегоНачисленоОборот - ПодоходныйНалогОбороты.ПФРДляРасчетаПНОборот - ПодоходныйНалогОбороты.ГНПФРДляРасчетаПНОборот - ПодоходныйНалогОбороты.ПНОборот
		|		ИНАЧЕ ЕСТЬNULL(ВременнаяТаблицаДоходы.ВсегоВыплаченноДохода, 0)
		|	КОНЕЦ КАК ВсегоВыплаченноДохода
		|ИЗ
		|	РегистрНакопления.ПодоходныйНалог.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			,
		|			Организация = &Организация
		|				И ФизЛицо В
		|					(ВЫБРАТЬ
		|						ВременнаяТаблицаСотрудники.ФизЛицо КАК ФизЛицо
		|					ИЗ
		|						ВременнаяТаблицаСотрудники КАК ВременнаяТаблицаСотрудники)) КАК ПодоходныйНалогОбороты
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаДоходы КАК ВременнаяТаблицаДоходы
		|		ПО ПодоходныйНалогОбороты.ФизЛицо = ВременнаяТаблицаДоходы.ФизЛицо";
	Запрос.УстановитьПараметр("НачалоПериода", ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ДатаОкончания));
	Запрос.УстановитьПараметр("Организация", Организация);	
	Запрос.УстановитьПараметр("Счет3520", ПланыСчетов.Хозрасчетный.НачисленнаяЗаработнаяПлата);
	Запрос.УстановитьПараметр("Счет1100", ПланыСчетов.Хозрасчетный.ДенежныеСредстваВКассе);
	Запрос.УстановитьПараметр("Счет1200", ПланыСчетов.Хозрасчетный.ДенежныеСредстваВБанке);
	Запрос.УстановитьПараметр("Счет1520", ПланыСчетов.Хозрасчетный.РасчетыСПодотчетнымиЛицами);
	Запрос.УстановитьПараметр("ЗаполнятьВыплатуПНПоНачислениям", Константы.ЗаполнятьВыплатуПНПоНачислениям.Получить());
	
	ОтчетГодовой.Загрузить(Запрос.Выполнить().Выгрузить());
		
КонецПроцедуры // ЗаполнитьТабличнуюЧастьОтчетГодовой()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру бухгалтерии Хозрасчетный.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	// 1. Оплата покупателя, Возврат покупателю
	// 2. Розничная выручка
	
	// Оплата покупателя, Возврат покупателю
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	1 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.БанковскийСчет.СчетУчета КАК СчетДт,
		|	ВременнаяТаблицаШапка.СчетРасчетов КАК СчетКт,
		|	ВременнаяТаблицаШапка.БанковскийСчет КАК СубконтоДт1,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.Контрагент КАК СубконтоКт1,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаРасшифровкаПлатежа.СуммаВзаиморасчетов * ВременнаяТаблицаШапка.КурсВзаиморасчетовПоНацБанку / ВременнаяТаблицаШапка.КратностьВзаиморасчетовПоНацБанку
		|	КОНЕЦ КАК Сумма,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДт,
		|	ВременнаяТаблицаШапка.ВалютаРасчетов КАК ВалютаКт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаВзаиморасчетов КАК ВалютнаяСуммаКт,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации) КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	(ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийОплатаПлатежнойКартой.ОплатаПокупателя)
		|			ИЛИ ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийОплатаПлатежнойКартой.ВозвратПокупателю))";
	ТекстЗапроса = ТекстЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|";
	
	// Розничная выручка
	ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ
		|	2 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.БанковскийСчет.СчетУчета КАК СчетДт,
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НачисленнаяЗаработнаяПлата) КАК СчетКт,
		|	ВременнаяТаблицаШапка.БанковскийСчет КАК СубконтоДт1,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт1,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК Сумма,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДт,
		|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа КАК ВалютнаяСуммаДт,
		|	0 КАК ВалютнаяСуммаКт,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации) КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийОплатаПлатежнойКартой.РозничнаяВыручка)";
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст = ТекстЗапроса;
	РезультатЗапроса = Запрос.Выполнить();	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаХозрасчетный", РезультатЗапроса.Выгрузить());
	
	// Подготовка таблицы для расчета операционных курсовых разниц.
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Контрагент КАК Контрагент,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	ВременнаяТаблицаШапка.СчетРасчетов КАК СчетРасчетов,
		|	ВременнаяТаблицаШапка.БанковскийСчет КАК КассаБанковскийСчет,
		|	ВременнаяТаблицаШапка.БанковскийСчет.СчетУчета КАК ДенежныйСчет,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДокумента,
		|	ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета,
		|	ВременнаяТаблицаШапка.ВалютаРасчетов КАК ВалютаРасчетов,
		|	ВременнаяТаблицаШапка.Курс КАК КурсДокумента,
		|	ВременнаяТаблицаШапка.Кратность КАК КратностьДокумента,
		|	СУММА(ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа) КАК СуммаПлатежа,
		|	СУММА(ВременнаяТаблицаРасшифровкаПлатежа.СуммаВзаиморасчетов) КАК СуммаВзаиморасчетов,
		|	ВременнаяТаблицаШапка.КурсВзаиморасчетовПоНацБанку КАК КурсВзаиморасчетовПоНацБанку,
		|	ВременнаяТаблицаШапка.КратностьВзаиморасчетовПоНацБанку КАК КратностьВзаиморасчетовПоНацБанку
		|ИЗ
		|	ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СчетаУчетаСОсобымПорядкомПереоценки КАК СчетаУчетаСОсобымПорядкомПереоценки
		|		ПО (ВременнаяТаблицаШапка.БанковскийСчет.СчетУчета = СчетаУчетаСОсобымПорядкомПереоценки.СчетУчета)
		|ГДЕ
		|	НЕ ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаДокумента
		|	И НЕ ВременнаяТаблицаШапка.КурсВзаиморасчетов = ВременнаяТаблицаШапка.КурсВзаиморасчетовПоНацБанку
		|	И НЕ ЕСТЬNULL(СчетаУчетаСОсобымПорядкомПереоценки.НеСчитатьОКР, ЛОЖЬ) = ИСТИНА
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.Контрагент,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента,
		|	ВременнаяТаблицаШапка.СчетРасчетов,
		|	ВременнаяТаблицаШапка.БанковскийСчет,
		|	ВременнаяТаблицаШапка.БанковскийСчет.СчетУчета,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета,
		|	ВременнаяТаблицаШапка.ВалютаРасчетов,
		|	ВременнаяТаблицаШапка.Курс,
		|	ВременнаяТаблицаШапка.Кратность,
		|	ВременнаяТаблицаШапка.КурсВзаиморасчетовПоНацБанку,
		|	ВременнаяТаблицаШапка.КратностьВзаиморасчетовПоНацБанку";
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДляРасчетаОперационныхКурсовыхРазниц", Запрос.Выполнить().Выгрузить());
КонецПроцедуры // СформироватьТаблицаХозрасчетный()

// Формирует таблицу значений, содержащую данные для проведения по регистру накопления ОборотыПоДаннымЕдиногоНалога.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаОборотыПоДаннымЕдиногоНалога(СтруктураДополнительныеСвойства)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаРасшифровкаПлатежа.ВидДеятельности КАК ВидДеятельности,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|	КОНЕЦ КАК СуммаБезналичная
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	&ПлательщикЕН
		|	И (ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийОплатаПлатежнойКартой.ОплатаПокупателя)
		|			ИЛИ ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийОплатаПлатежнойКартой.ВозвратПокупателю))";
	Запрос.УстановитьПараметр("ПлательщикЕН", СтруктураДополнительныеСвойства.УчетнаяПолитика.ПлательщикЕНКассовыйМетод);	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ОборотыПоДаннымЕдиногоНалога", РезультатЗапроса.Выгрузить());
КонецПроцедуры

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Дата КАК Дата,
		|	ТаблицаДокумента.Организация КАК Организация,
		|	ТаблицаДокумента.ВидОперации КАК ВидОперации,
		|	ТаблицаДокумента.БанковскийСчет КАК БанковскийСчет,
		|	ТаблицаДокумента.ВалютаДокумента КАК ВалютаДокумента,
		|	&Курс КАК Курс,
		|	&Кратность КАК Кратность,
		|	ТаблицаДокумента.Контрагент КАК Контрагент,
		|	ТаблицаДокумента.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	ТаблицаДокумента.ВалютаРасчетов КАК ВалютаРасчетов,
		|	&КурсВзаиморасчетовПоНацБанку КАК КурсВзаиморасчетовПоНацБанку,
		|	&КратностьВзаиморасчетовПоНацБанку КАК КратностьВзаиморасчетовПоНацБанку,
		|	ТаблицаДокумента.СчетРасчетов КАК СчетРасчетов,
		|	ТаблицаДокумента.КурсВзаиморасчетов КАК КурсВзаиморасчетов,
		|	ТаблицаДокумента.КратностьВзаиморасчетов КАК КратностьВзаиморасчетов,
		|	ТаблицаДокумента.ВидОплаты КАК ВидОплаты,
		|	ТаблицаДокумента.СуммаДокумента КАК СуммаДокумента,
		|	&ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.ОплатаПлатежнойКартой КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ВидДеятельности КАК ВидДеятельности,
		|	ТаблицаДокумента.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
		|	ТаблицаДокумента.СуммаПлатежа КАК СуммаПлатежа,
		|	ТаблицаДокумента.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов
		|ПОМЕСТИТЬ ВременнаяТаблицаРасшифровкаПлатежа
		|ИЗ
		|	Документ.ОплатаПлатежнойКартой.РасшифровкаПлатежа КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка";				
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);	
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", СтруктураДополнительныеСвойства.ДляПроведения.ВалютаРегламентированногоУчета);	
	// Курсы.
	КурсВалютыДокумента = РаботаСКурсамиВалют.ПолучитьКурсВалюты(СтруктураДополнительныеСвойства.ДляПроведения.ВалютаДокумента, 		
		СтруктураДополнительныеСвойства.ДляПроведения.Дата);
	Запрос.УстановитьПараметр("Курс", ?(ЗначениеЗаполнено(КурсВалютыДокумента.Курс), КурсВалютыДокумента.Курс, 1));	
	Запрос.УстановитьПараметр("Кратность", ?(ЗначениеЗаполнено(КурсВалютыДокумента.Кратность), КурсВалютыДокумента.Кратность, 1));	
	
	ВалютаРасчетов =  
	?(СтруктураДополнительныеСвойства.ДляПроведения.ВалютаРасчетов = СтруктураДополнительныеСвойства.ДляПроведения.ВалютаРегламентированногоУчета,
		СтруктураДополнительныеСвойства.ДляПроведения.ВалютаДокумента, 
		СтруктураДополнительныеСвойства.ДляПроведения.ВалютаРасчетов);	

	КурсВалютыРасчетов = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, 		
		СтруктураДополнительныеСвойства.ДляПроведения.Дата);
	Запрос.УстановитьПараметр("КурсВзаиморасчетовПоНацБанку", ?(ЗначениеЗаполнено(КурсВалютыРасчетов.Курс), КурсВалютыРасчетов.Курс, 1));	
	Запрос.УстановитьПараметр("КратностьВзаиморасчетовПоНацБанку", ?(ЗначениеЗаполнено(КурсВалютыРасчетов.Кратность), КурсВалютыРасчетов.Кратность, 1));	
	
	Запрос.Выполнить();
	
	СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаОборотыПоДаннымЕдиногоНалога(СтруктураДополнительныеСвойства);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#КонецОбласти

#Область ВерсионированиеОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//@skip-warning
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#КонецЕсли

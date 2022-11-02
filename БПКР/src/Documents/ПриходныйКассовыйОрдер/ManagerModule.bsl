#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру бухгалтерии Хозрасчетный.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	// 1. Оплата от покупателя, Возврат от поставщика, Расчеты по займам
	// 2. Возврат от сотрудника
	// 3. Возврат от подотчетника
	// 4. Получение наличных в банке
	// 5. Прочий приход
	// 6. Конвертация
	ТекстыЗапроса = Новый Массив;
	
	// Оплата от покупателя, Возврат от поставщика, Расчеты по займам.
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	1 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета КАК СчетДт,
		|	ВременнаяТаблицаШапка.СчетРасчетов КАК СчетКт,
		|	ВременнаяТаблицаШапка.Касса КАК СубконтоДт1,
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
		|	(ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ОплатаОтПокупателя)
		|			ИЛИ ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ВозвратОтПоставщика)
		|			ИЛИ ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.РасчетыПоЗаймам)
		|			ИЛИ ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.РозничнаяВыручка))";
	ТекстыЗапроса.Добавить(ТекстЗапроса);
	
	// Возврат от сотрудника.
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	2 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета КАК СчетДт,
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НачисленнаяЗаработнаяПлата) КАК СчетКт,
		|	ВременнаяТаблицаШапка.Касса КАК СубконтоДт1,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.ФизЛицо КАК СубконтоКт1,
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
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ВозвратОтСотрудника)
		|	И НЕ &ВозвратОтрицательнойСуммой
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	2,
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НачисленнаяЗаработнаяПлата),
		|	ВременнаяТаблицаШапка.Касса.СчетУчета,
		|	ВременнаяТаблицаШапка.ФизЛицо,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаШапка.Касса,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств,
		|	НЕОПРЕДЕЛЕНО,
		|	-(ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность),
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	0,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации)
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ВозвратОтСотрудника)
		|	И &ВозвратОтрицательнойСуммой";
	ТекстыЗапроса.Добавить(ТекстЗапроса);
	
	// Возврат от подотчетника.
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	3 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета КАК СчетДт,
		|	ВременнаяТаблицаШапка.СчетРасчетов КАК СчетКт,
		|	ВременнаяТаблицаШапка.Касса КАК СубконтоДт1,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.ФизЛицо КАК СубконтоКт1,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК Сумма,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДт,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаКт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа КАК ВалютнаяСуммаКт,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации) КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ВозвратОтПодотчетника)";
	ТекстыЗапроса.Добавить(ТекстЗапроса);
	
	// Получение наличных в банке.
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	4 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета КАК СчетДт,
		|	ВременнаяТаблицаШапка.БанковскийСчет.СчетУчета КАК СчетКт,
		|	ВременнаяТаблицаШапка.Касса КАК СубконтоДт1,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.БанковскийСчет КАК СубконтоКт1,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредствВнутренниеОбороты КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК Сумма,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДт,
		|	ВременнаяТаблицаШапка.ВалютаРасчетов КАК ВалютаКт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа КАК ВалютнаяСуммаКт,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации) КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ПолучениеНаличныхВБанке)";
	ТекстыЗапроса.Добавить(ТекстЗапроса);
	
	// Прочий приход.
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	5 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета КАК СчетДт,
		|	ВременнаяТаблицаПрочиеПлатежи.СчетРасчетов КАК СчетКт,
		|	ВременнаяТаблицаШапка.Касса КАК СубконтоДт1,
		|	ВременнаяТаблицаПрочиеПлатежи.СтатьяДвиженияДенежныхСредств КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВременнаяТаблицаПрочиеПлатежи.Субконто1 КАК СубконтоКт1,
		|	ВременнаяТаблицаПрочиеПлатежи.Субконто2 КАК СубконтоКт2,
		|	ВременнаяТаблицаПрочиеПлатежи.Субконто3 КАК СубконтоКт3,
		|	ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК Сумма,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДт,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаКт,
		|	ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа КАК ВалютнаяСуммаКт,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации) КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаПрочиеПлатежи КАК ВременнаяТаблицаПрочиеПлатежи
				|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ПрочийПриход)";
	ТекстыЗапроса.Добавить(ТекстЗапроса);
	
	// Конвертация.
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	6 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета КАК СчетДт,
		//|	ВременнаяТаблицаШапка.СчетРасчетов КАК СчетКт,
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ДенежныеСредстваВПути) КАК СчетКт,
		|	ВременнаяТаблицаШапка.Касса КАК СубконтоДт1,
		|	&СтатьяДДСДляВнутреннихОборотов КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.Касса КАК СубконтоКт1,
		|	&СтатьяДДСДляВнутреннихОборотов КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
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
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.Конвертация)";
	ТекстыЗапроса.Добавить(ТекстЗапроса);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст = СтрСоединить(ТекстыЗапроса, Символы.ПС + " ОБЪЕДИНИТЬ ВСЕ " + Символы.ПС);
	Запрос.УстановитьПараметр("СтатьяДДСДляВнутреннихОборотов", БухгалтерскийУчетСервер.СтатьяДДСДляВнутреннихОборотов());
	Запрос.УстановитьПараметр("ВозвратОтрицательнойСуммой",БухгалтерскийУчетСервер.ПолучитьДанныеУчетнойПолитикиПоПерсоналу(СтруктураДополнительныеСвойства.ДляПроведения.Дата, СтруктураДополнительныеСвойства.ДляПроведения.Организация).ВозвратОтрицательнойСуммой);
	
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
		|	ВременнаяТаблицаШапка.Касса КАК КассаБанковскийСчет,
		|	ВременнаяТаблицаШапка.Касса КАК КассаБанковскийСчетПриход,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.Конвертация)
		|			ТОГДА ВременнаяТаблицаШапка.Касса
		|		ИНАЧЕ ВременнаяТаблицаШапка.БанковскийСчет
		|	КОНЕЦ КАК КассаБанковскийСчетРасход,
		|	ВременнаяТаблицаШапка.СчетРасчетов КАК СчетРасчетов,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета КАК ДенежныйСчет,
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
		|		ПО (ВременнаяТаблицаШапка.Касса.СчетУчета = СчетаУчетаСОсобымПорядкомПереоценки.СчетУчета)
		|ГДЕ
		|	НЕ ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаДокумента
		|	И НЕ ВременнаяТаблицаШапка.КурсВзаиморасчетов = ВременнаяТаблицаШапка.КурсВзаиморасчетовПоНацБанку
		|	И НЕ ЕСТЬNULL(СчетаУчетаСОсобымПорядкомПереоценки.НеСчитатьОКР, ЛОЖЬ) = ИСТИНА
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаШапка.КурсВзаиморасчетовПоНацБанку,
		|	ВременнаяТаблицаШапка.КратностьВзаиморасчетовПоНацБанку,
		|	ВременнаяТаблицаШапка.Контрагент,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.Конвертация)
		|			ТОГДА ВременнаяТаблицаШапка.Касса
		|		ИНАЧЕ ВременнаяТаблицаШапка.БанковскийСчет
		|	КОНЕЦ,
		|	ВременнаяТаблицаШапка.СчетРасчетов,
		|	ВременнаяТаблицаШапка.Курс,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.Касса,
		|	ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета,
		|	ВременнаяТаблицаШапка.ВалютаРасчетов,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета,
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Кратность,
		|	ВременнаяТаблицаШапка.Касса";

	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДляРасчетаОперационныхКурсовыхРазниц", Запрос.Выполнить().Выгрузить());
КонецПроцедуры // СформироватьТаблицаХозрасчетный()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаВыплаченнаяЗарплата(ДокументСсылка, СтруктураДополнительныеСвойства)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Дата КАК ПериодРегистрации,
		|	ВременнаяТаблицаШапка.ФизЛицо КАК ФизЛицо,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыВыплатыЗарплаты.ЧерезКассу) КАК ВидВыплаты,
		|	-ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК Сумма
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ВозвратОтСотрудника)";
	РезультатЗапроса = Запрос.Выполнить();
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаВыплаченнаяЗарплата", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаВыплаченнаяЗарплата()

// Формирует таблицу значений, содержащую данные для проведения по регистру накопления ВозвратДенежныхСредствПодотчетником.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаОтразитьВозвратПодотчетником(СтруктураДополнительныеСвойства)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.ФизЛицо КАК ФизЛицо,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|	КОНЕЦ КАК Сумма
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ВозвратОтПодотчетника)";	
	РезультатЗапроса = Запрос.Выполнить();	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаОтразитьВозвратПодотчетником", РезультатЗапроса.Выгрузить());
КонецПроцедуры

// Формирует таблицу значений, содержащую данные для проведения по регистру "АвансыПодотчетника".
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаАвансыПодотчетника(ДокументСсылка,СтруктураДополнительныеСвойства)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		// Удалить после обновления на 3.1.11
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.ФизЛицо КАК ФизЛицо,
		|	ВременнаяТаблицаШапка.СчетРасчетов КАК СчетУчета,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК Валюта,
		|	ВременнаяТаблицаШапка.Дата КАК ДатаАванса,
		|	ВременнаяТаблицаШапка.Ссылка КАК ДокументАванса,
		|	-ВременнаяТаблицаШапка.СуммаДокумента КАК Сумма
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации =  ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ВозвратОтПодотчетника)";	
	РезультатЗапроса = Запрос.Выполнить();	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаАвансыПодотчетника", РезультатЗапроса.Выгрузить());
КонецПроцедуры

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
		|	КОНЕЦ КАК СуммаНаличная
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	&ПлательщикЕН
		|	И ВременнаяТаблицаШапка.ВидОперации В(&ВидыОпераций)";
	Запрос.УстановитьПараметр("ПлательщикЕН", СтруктураДополнительныеСвойства.УчетнаяПолитика.ПлательщикЕНКассовыйМетод);	
	Запрос.УстановитьПараметр("ВидыОпераций", ОбщегоНазначенияБПСервер.ВидыОперацийЕдиныйНалог());	
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
		|	ТаблицаДокумента.Ссылка КАК Ссылка,
		|	ТаблицаДокумента.Дата КАК Дата,
		|	ТаблицаДокумента.Организация КАК Организация,
		|	ТаблицаДокумента.ВидОперации КАК ВидОперации,
		|	ТаблицаДокумента.Касса КАК Касса,
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
		|	ТаблицаДокумента.ФизЛицо КАК ФизЛицо,
		|	ТаблицаДокумента.БанковскийСчет КАК БанковскийСчет,
		|	ТаблицаДокумента.СуммаДокумента КАК СуммаДокумента,
		|	&ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.ПриходныйКассовыйОрдер КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ВидДеятельности КАК ВидДеятельности,
		|	ТаблицаДокумента.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
		|	ТаблицаДокумента.СтатьяДвиженияДенежныхСредствВнутренниеОбороты КАК СтатьяДвиженияДенежныхСредствВнутренниеОбороты,
		|	ТаблицаДокумента.СуммаПлатежа КАК СуммаПлатежа,
		|	ТаблицаДокумента.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов
		|ПОМЕСТИТЬ ВременнаяТаблицаРасшифровкаПлатежа
		|ИЗ
		|	Документ.ПриходныйКассовыйОрдер.РасшифровкаПлатежа КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
		|	ТаблицаДокумента.СуммаПлатежа КАК СуммаПлатежа,
		|	ТаблицаДокумента.СчетРасчетов КАК СчетРасчетов,
		|	ТаблицаДокумента.Субконто1 КАК Субконто1,
		|	ТаблицаДокумента.Субконто2 КАК Субконто2,
		|	ТаблицаДокумента.Субконто3 КАК Субконто3
		|ПОМЕСТИТЬ ВременнаяТаблицаПрочиеПлатежи
		|ИЗ
		|	Документ.ПриходныйКассовыйОрдер.ПрочиеПлатежи КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка";				
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);	
	Запрос.УстановитьПараметр("Период", СтруктураДополнительныеСвойства.ДляПроведения.Дата);	
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
	СформироватьТаблицаОтразитьВозвратПодотчетником(СтруктураДополнительныеСвойства);
	СформироватьТаблицаАвансыПодотчетника(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаВыплаченнаяЗарплата(ДокументСсылка, СтруктураДополнительныеСвойства);
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

#Область ИнтерфейсПечати

// Функция формирует табличный документ с печатной формой Кассовый ордер форма №1
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьКассовыйОрдер(МассивОбъектов, ОбъектыПечати)
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	ПриходныйКассовыйОрдерПрочиеПлатежи.Ссылка КАК Регистратор,
		|	ПриходныйКассовыйОрдерПрочиеПлатежи.СчетРасчетов КАК СчетКт
		|ИЗ
		|	Документ.ПриходныйКассовыйОрдер.ПрочиеПлатежи КАК ПриходныйКассовыйОрдерПрочиеПлатежи
		|ГДЕ
		|	ПриходныйКассовыйОрдерПрочиеПлатежи.Ссылка В(&СписокДокументов)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПриходныйКассовыйОрдер.Ссылка КАК Ссылка,
		|	ПриходныйКассовыйОрдер.Номер КАК Номер,
		|	ПриходныйКассовыйОрдер.Дата КАК Дата,
		|	ПриходныйКассовыйОрдер.ВидОперации КАК ВидОперации,
		|	ПриходныйКассовыйОрдер.Касса КАК Касса,
		|	ПриходныйКассовыйОрдер.Касса.СчетУчета КАК СчетДт,
		|	ВЫБОР
		|		КОГДА ПриходныйКассовыйОрдер.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ВозвратОтСотрудника)
		|			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НачисленнаяЗаработнаяПлата)
		|		КОГДА ПриходныйКассовыйОрдер.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ПолучениеНаличныхВБанке)
		|			ТОГДА ПриходныйКассовыйОрдер.БанковскийСчет.СчетУчета
		|		ИНАЧЕ ПриходныйКассовыйОрдер.СчетРасчетов
		|	КОНЕЦ КАК СчетКт,
		|	&ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета,
		|	ПриходныйКассовыйОрдер.ВалютаДокумента КАК ВалютаДокумента,
		|	ПриходныйКассовыйОрдер.ВалютаДокумента.Наименование КАК ВалютаНаименование,
		|	ПриходныйКассовыйОрдер.СуммаДокумента КАК СуммаДокумента,
		// Реквизиты организации.
		|	ПриходныйКассовыйОрдер.Организация КАК Организация,
		|	ПриходныйКассовыйОрдер.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	ПриходныйКассовыйОрдер.Организация.КодПоОКПО КАК ОрганизацияКодПоОКПО,
		// Реквизиты платежа.
		|	ПриходныйКассовыйОрдер.ПринятоОт КАК ПринятоОт,
		|	ПриходныйКассовыйОрдер.Основание КАК Основание,
		|	ПриходныйКассовыйОрдер.Приложение КАК Приложение
		|ИЗ
		|	Документ.ПриходныйКассовыйОрдер КАК ПриходныйКассовыйОрдер
		|ГДЕ
		|	ПриходныйКассовыйОрдер.Ссылка В(&СписокДокументов)";		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицаСчетов = МассивРезультатов[0].Выгрузить();
	ТаблицаСчетов.Индексы.Добавить("Регистратор");
	
	Шапка = МассивРезультатов[1].Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПриходныйКассовыйОрдер_КассовыйОрдер";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПриходныйКассовыйОрдер.ПФ_MXL_КассовыйОрдер");
	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;
		
		ДанныеПечати.Вставить("ДатаДокумента", Формат(Шапка.Дата, "ДЛФ=D"));
		НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.Номер);
		ДанныеПечати.Вставить("НомерДокумента", НомерНаПечать);
		ДанныеПечати.Вставить("ОрганизацияНаименованиеПолное", Шапка.ОрганизацияНаименованиеПолное);
		ДанныеПечати.Вставить("ОрганизацияКодПоОКПО", Шапка.ОрганизацияКодПоОКПО);
		ДанныеПечати.Вставить("ВалютаНаименование", Шапка.ВалютаНаименование);
		Если НЕ Шапка.ВалютаДокумента = Шапка.ВалютаРегламентированногоУчета Тогда
			ВалютаДокументаКурсКратность = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Шапка.ВалютаДокумента, Шапка.Дата);
			ДанныеПечати.Вставить("РасшифровкаКурса", СтрШаблон(НСтр("ru = 'Курс: %1'"), ВалютаДокументаКурсКратность.Курс / ВалютаДокументаКурсКратность.Кратность));
		КонецЕсли;	
		
		ДанныеПечати.Вставить("СчетДт", Шапка.СчетДт);
		
		Если Шапка.ВидОперации = Перечисления.ВидыОперацийПКО.ПрочийПриход Тогда 
			СтрокаСчетКт = "";
			
			НайденныеСтроки = ТаблицаСчетов.НайтиСтроки(Новый Структура("Регистратор", Шапка.Ссылка));
			Для Каждого НайденнаяСтрокаТаблицы Из НайденныеСтроки Цикл
				Если СтрНайти(СтрокаСчетКт, НайденнаяСтрокаТаблицы.СчетКт) = 0 Тогда   
					Если НЕ СтрокаСчетКт = "" Тогда 
						СтрокаСчетКт = СтрокаСчетКт + ", ";
					КонецЕсли;	
					СтрокаСчетКт = СтрокаСчетКт + НайденнаяСтрокаТаблицы.СчетКт;
				КонецЕсли;	
			КонецЦикла;
			
			ДанныеПечати.Вставить("СчетКт", СтрокаСчетКт);
		Иначе 		
			ДанныеПечати.Вставить("СчетКт", Шапка.СчетКт);
		КонецЕсли;	
		
		ДанныеПечати.Вставить("ПринятоОт", Шапка.ПринятоОт);
		ДанныеПечати.Вставить("Основание", Шапка.Основание);
		ДанныеПечати.Вставить("Приложение", Шапка.Приложение);
		
		ДанныеПечати.Вставить("СуммаДокумента", Формат(Шапка.СуммаДокумента, "ЧЦ=15; ЧДЦ=2; ЧГ=3,0"));
		ДанныеПечати.Вставить("СуммаДокументаСВалютой", БухгалтерскийУчетСервер.СформироватьСуммуСВалютой(Шапка.СуммаДокумента, Шапка.ВалютаДокумента));
		ДанныеПечати.Вставить("СуммаПрописью", БухгалтерскийУчетСервер.СформироватьСуммуПрописью(Шапка.СуммаДокумента, Шапка.ВалютаДокумента));
		                                     
		// Подписи.
		ФамилияИОГлавногоБухгалтера = "";
		ФамилияИОКассира = "";
		ОтветственныеЛица = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизацийРуководители(Шапка.Организация, Шапка.Дата, Новый Структура("Касса", Шапка.Касса));
		БухгалтерскийУчетСервер.ФамилияИнициалыПоНаименованию(ФамилияИОГлавногоБухгалтера, ОтветственныеЛица.ГлавныйБухгалтер);
		БухгалтерскийУчетСервер.ФамилияИнициалыПоНаименованию(ФамилияИОКассира, ОтветственныеЛица.Кассир);
		
		ДанныеПечати.Вставить("ФамилияИОГлавногоБухгалтера", ФамилияИОГлавногоБухгалтера);
		ДанныеПечати.Вставить("ФамилияИОКассира", ФамилияИОКассира);
		
		// Области
		МассивОбластейМакета = Новый Массив;
		МассивОбластейМакета.Добавить("Заголовок");
		
		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	// Проверяем, нужно ли для макета ПКО формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_КассовыйОрдер") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"ПФ_MXL_КассовыйОрдер", НСтр("ru = 'Печать ПКО'"), ПечатьКассовыйОрдер(МассивОбъектов, ОбъектыПечати),,
			"Документ.ПриходныйКассовыйОрдер.ПФ_MXL_КассовыйОрдер");
	КонецЕсли;	
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПФ_MXL_КассовыйОрдер";
	КомандаПечати.Представление = НСтр("ru = 'Печать ПКО'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "РеестрПриходныйКассовыйОрдер";
	КомандаПечати.Представление  = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Реестр документов ""Приходный кассовый ордер""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
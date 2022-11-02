#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		
#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаСведенияОбЭСФ(ДокументСсылка, СтруктураДополнительныеСвойства) 
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВременнаяТаблицаШапка.Дата КАК Дата,
		|	ВременнаяТаблицаШапка.ДатаПоставки КАК ДатаПоставки,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.НомерЭСФ КАК НомерЭСФ,
		|	ВременнаяТаблицаШапка.НомерКорректируемогоЭСФ КАК НомерКорректируемогоЭСФ,
		|	ВременнаяТаблицаШапка.СерияКорректируемогоСФ КАК СерияКорректируемогоСФ,
		|	ВременнаяТаблицаШапка.ДатаКорректируемогоЭСФ КАК ДатаКорректируемогоЭСФ,
		//|	ВременнаяТаблицаШапка.Ссылка КАК ДокументСсылка,
		|	ВременнаяТаблицаТовары.ДокументОснование КАК ДокументОснование
		|ИЗ
		|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСведенияОбЭСФ", РезультатЗапроса.Выгрузить());
КонецПроцедуры     

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства, Отказ) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЭлектронныйСчетФактураПолученный.Ссылка КАК Ссылка,
		|	ЭлектронныйСчетФактураПолученный.Организация КАК Организация,
		|	ЭлектронныйСчетФактураПолученный.Дата КАК Дата,
		|	ЭлектронныйСчетФактураПолученный.ДатаПоставки КАК ДатаПоставки,
		|	ЭлектронныйСчетФактураПолученный.НомерЭСФ КАК НомерЭСФ,
		|	ЭлектронныйСчетФактураПолученный.СерияКорректируемогоСФ КАК СерияКорректируемогоСФ,
		|	ЭлектронныйСчетФактураПолученный.НомерКорректируемогоЭСФ КАК НомерКорректируемогоЭСФ,
		|	ЭлектронныйСчетФактураПолученный.ДатаКорректируемогоЭСФ КАК ДатаКорректируемогоЭСФ
		//|	ЭлектронныйСчетФактураПолученный.КодСпособаОтправки КАК КодСпособаОтправки
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.ЭлектронныйСчетФактураПолученный КАК ЭлектронныйСчетФактураПолученный
		|ГДЕ
		|	ЭлектронныйСчетФактураПолученный.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЭлектронныйСчетФактураПолученныйТовары.ДокументОснование КАК ДокументОснование
		|ПОМЕСТИТЬ ВременнаяТаблицаТовары
		|ИЗ
		|	Документ.ЭлектронныйСчетФактураПолученный.Товары КАК ЭлектронныйСчетФактураПолученныйТовары
		|ГДЕ
		|	ЭлектронныйСчетФактураПолученныйТовары.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Выполнить();
	
	СформироватьТаблицаСведенияОбЭСФ(ДокументСсылка, СтруктураДополнительныеСвойства); 	
КонецПроцедуры

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

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "РеестрПоступлениеИзПереработки";     
	КомандаПечати.Представление  = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Реестр документов ""Электронный счет-фактура (полученный)""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
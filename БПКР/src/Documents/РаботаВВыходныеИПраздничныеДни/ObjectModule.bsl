#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
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
	
	// Инициализация дополнительных свойств для удаления проведения документа
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
		
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ПроверяемыеРеквизиты.Добавить("Сотрудники");	
	
	// Предварительный контроль
	ВыполнитьПредварительныйКонтроль(Отказ);	

КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииОбработкаПроведения

// Процедура инициализирует данные документа
// и подготавливает таблицы для движения в регистры
//
Процедура ИнициализироватьДанные(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.РаботаВВыходныеИПраздничныеДни.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
КонецПроцедуры
	
// Процедура заполняет регистры данными
//
Процедура ОтразитьДвижения(Отказ, РежимПроведения)

	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьНачисления(ДополнительныеСвойства, Движения, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
		|	ТаблицаДокумента.ФизЛицо КАК ФизЛицо,
		|	ТаблицаДокумента.ДатаНачала КАК ДатаНачала,
		|	ТаблицаДокумента.ДатаОкончания КАК ДатаОкончания
		|ПОМЕСТИТЬ ВременнаяТаблицаСотрудники
		|ИЗ
		|	&ВременнаяТаблицаСотрудники КАК ТаблицаДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаСотрудники.НомерСтроки КАК НомерСтроки,
		|	ВременнаяТаблицаСотрудники.ФизЛицо КАК ФизЛицо
		|ИЗ
		|	ВременнаяТаблицаСотрудники КАК ВременнаяТаблицаСотрудники
		|ГДЕ
		|	(НЕ НАЧАЛОПЕРИОДА(ВременнаяТаблицаСотрудники.ДатаНачала, МЕСЯЦ) = НАЧАЛОПЕРИОДА(ВременнаяТаблицаСотрудники.ДатаОкончания, МЕСЯЦ)
		|			ИЛИ ВременнаяТаблицаСотрудники.ДатаНачала > ВременнаяТаблицаСотрудники.ДатаОкончания)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ТаблицаДублиСтрок.НомерСтроки) КАК НомерСтроки,
		|	ТаблицаДублиСтрок.ФизЛицо КАК ФизЛицо
		|ИЗ
		|	ВременнаяТаблицаСотрудники КАК ВременнаяТаблицаСотрудники
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаСотрудники КАК ТаблицаДублиСтрок
		|		ПО ВременнаяТаблицаСотрудники.НомерСтроки <> ТаблицаДублиСтрок.НомерСтроки
		|			И ВременнаяТаблицаСотрудники.ФизЛицо = ТаблицаДублиСтрок.ФизЛицо
		|			И ВременнаяТаблицаСотрудники.ДатаНачала = ТаблицаДублиСтрок.ДатаНачала
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаДублиСтрок.ФизЛицо
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки");                          	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Параметры.Вставить("Организация", Организация);
	Запрос.Параметры.Вставить("ВременнаяТаблицаСотрудники", Сотрудники.Выгрузить());
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Месяц начала и окончания периода должен быть одинаковым.
	Если НЕ МассивРезультатов[1].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Период указан не верно в строке %1 списка ""Сотрудники"".'"), 
							ВыборкаИзРезультатаЗапроса.НомерСтроки);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"ДатаНачала",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"Сотрудники",
				Отказ);
		КонецЦикла;
	КонецЕсли;
	
	// Дубли строк.
	Если НЕ МассивРезультатов[2].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[2].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Сотрудник указывается повторно в строке %1 списка ""Сотрудники"".'"), 
							ВыборкаИзРезультатаЗапроса.НомерСтроки);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"ФизЛицо",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"Сотрудники",
				Отказ);
		КонецЦикла;
	КонецЕсли;	

КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
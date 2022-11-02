#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	СчетЗатрат = ПланыСчетов.Хозрасчетный.ОсновноеПроизводство; // 1630
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	СтруктураДанные = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ДоговорКонтрагента.ВалютаРасчетов, Дата);
	Курс      = ?(СтруктураДанные.Курс = 0, 1, СтруктураДанные.Курс);
	Кратность = ?(СтруктураДанные.Кратность = 0, 1, СтруктураДанные.Кратность);
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
		
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПроверяемыеРеквизиты.Добавить("Продукция");
	
	Если Курс = 0 Или Кратность = 0 Тогда 
		ТекстСообщения = НСтр("ru = 'Не заполнен курс валюты ""%1"". Откройте список валют (Банк и касса - Валюты) и проверьте,
			|что у валюты ""%1"" установлен курс на дату %2 или ранее.
			|Перевыберите договор и заново проведите документ.'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ВалютаДокумента, Формат(Дата, "ДЛФ=D"));	
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
	КонецЕсли;
	
	// Контроль заполнения Контрагента ГНС.
	Если Контрагент.ПризнакСтраны = Перечисления.ПризнакиСтраны.ЕАЭС Тогда 
		КонтрагентГНС = Организация.КонтрагентГНС;
		Если НЕ ЗначениеЗаполнено(КонтрагентГНС) Тогда 
			ТекстСообщения = НСтр("ru = 'Не заполнен Контрагент ГНС. Откройте организацию и проверьте, что поле Контрагент ГНС заполнено.
				|Заново проведите документ.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.Организация",, Отказ);
		Иначе 
			СписокВидовДоговора = Новый СписокЗначений;
			СписокВидовДоговора.Добавить(Перечисления.ВидыДоговоровКонтрагентов.Прочее);
			ДоговорКонтрагентаГНС = Справочники.ДоговорыКонтрагентов.ПолучитьДоговорПоУмолчаниюПоОрганизацииВидуДоговора(КонтрагентГНС, Организация, СписокВидовДоговора);
			
			Если НЕ ЗначениеЗаполнено(ДоговорКонтрагентаГНС) Тогда 
				ТекстСообщения = НСтр("ru = 'Не установлен основной договор у Контрагента ГНС.
					|Откройте организацию и перейдите к указанному Контрагенту ГНС. На вкладке Договоры контрагента установите основной договор.
					|Вид договора должен быть Прочее, валюта договора KGS. Заново проведите документ.'");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.Организация",, Отказ);
			КонецЕсли;	
		КонецЕсли;	
	КонецЕсли;	
	
	//// Проверка договора в валюте регламентированного учета.
	//ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	//Если Контрагент.ПризнакСтраны = Перечисления.ПризнакиСтраны.КР 
	//	И ДоговорКонтрагента.ВалютаРасчетов <> ВалютаРегламентированногоУчета Тогда
	//	
	//	ТекстСообщения = СтрШаблон(НСтр("ru = 'Для контрагента с признаком страны ""КР"" необходимо выбрать договор с валютой %1.'"),
	//						ВалютаРегламентированногоУчета);
	//	ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.ДоговорКонтрагента",, Отказ);
	//КонецЕсли;	
	
	Если ЭтоПоступлениеБезНДС Тогда 
		ПроверяемыеРеквизиты.Добавить("НомерБланкаСФ");	
	КонецЕсли;	
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

	// Предварительный контроль	
	ВыполнитьПредварительныйКонтроль(Отказ);
КонецПроцедуры

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СуммаДокумента = Продукция.Итог("СуммаПлановая") + Услуги.Итог("Всего");
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ИнициализироватьДанные(Отказ, РежимПроведения);
	
	ОтразитьДвижения(Отказ, РежимПроведения);
	
	// Запись наборов записей.
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры

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
	Документы.ПоступлениеИзПереработки.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
КонецПроцедуры
	
// Процедура заполняет регистры данными
//
Процедура ОтразитьДвижения(Отказ, РежимПроведения)

	
	// Отражение в разделах учета.
	УчетПроизводства.СформироватьДвиженияПлановаяСтоимостьВыпущеннойПродукции(ДополнительныеСвойства, Движения, Отказ);
	УчетПроизводства.СформироватьДвиженияВыпускПродукции(ДополнительныеСвойства, Движения, Отказ);
	// Списание материалов на расходы производства
	УчетТоваров.СформироватьДвиженияСписаниеТоваров(ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаСписанныеМатериалы, 
		ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизитыМатериалы, Движения, Отказ, ДополнительныеСвойства);
	// Отходы.
	УчетПроизводства.СформироватьДвиженияВыпускОтходов(ДополнительныеСвойства, Движения, Отказ);
	
	БухгалтерскийУчетСервер.ОтразитьХозрасчетный(ДополнительныеСвойства, Движения, Отказ);
	
	// Прочее
	БухгалтерскийУчетСервер.ОтразитьПоступлениеТоваров(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСведенияОПоступлении(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ЗначенияСтавокНалогов(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьРеестрПриобретенныхМатериальныхРесурсов(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьРеестрЗакупок(ДополнительныеСвойства, Движения, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПодготовитьПараметрыРасчета(ПараметрыДляВозвратныхОтходов) Экспорт 

	ПризнакСтраныЕАЭС 			= Контрагент.ПризнакСтраны = Перечисления.ПризнакиСтраны.ЕАЭС;
	ПризнакСтраныИмпортЭкспорт 	= Контрагент.ПризнакСтраны = Перечисления.ПризнакиСтраны.ИмпортЭкспорт;
	
	ПараметрыРасчета = ОбработкаТабличныхЧастейКлиентСервер.ШаблонПараметровРасчета();
	ПараметрыРасчета.ПризнакСтраныЕАЭС = ПризнакСтраныЕАЭС;
	ПараметрыРасчета.ЕстьАкциз = Ложь;
	ПараметрыРасчета.СуммаВключаетНалоги = СуммаВключаетНалоги;
	ПараметрыРасчета.ЗначениеСтавкиНДС = ЗначениеСтавкиНДС;
	ПараметрыРасчета.БезналичныйРасчет = БезналичныйРасчет;
	
	Если Контрагент.ПризнакСтраны = Перечисления.ПризнакиСтраны.КР
		И НЕ ПараметрыДляВозвратныхОтходов Тогда
		ПараметрыРасчета.КурсДокумента = 1;
		ПараметрыРасчета.КратностьДокумента = 1;	
	Иначе	
		ПараметрыРасчета.КурсДокумента = Курс;
		ПараметрыРасчета.КратностьДокумента = Кратность;
	КонецЕсли;	
		
	ПараметрыРасчета.РассчитатьБазуНДС = ПризнакСтраныЕАЭС;
	ПараметрыРасчета.РассчитатьОтБазыНДС = ПризнакСтраныЕАЭС;
	ПараметрыРасчета.ПризнакСтраныИмпортЭкспорт = ПризнакСтраныИмпортЭкспорт;
	ПараметрыРасчета.Точность = ТочностьЦены;

	Возврат ПараметрыРасчета;
КонецФункции

// Заполняет табличную часть Материалы на основании данных табличной частй Продукция.
// Процедура добавляет строки, не очищая табличную часть перед заполнением.
// Счета учета не заполняются. При необходимости, об этом должен позаботиться вызывающий код.
// 
Процедура ЗаполнитьМатериалыПоПродукции() Экспорт
	
	// Получим данные о сырье для заполнения табличной части
	ТекстыЗапроса = Новый Массив;
	// Исходные данные
	ТекстыЗапроса.Добавить(
		"ВЫБРАТЬ
		|	0 КАК НомерСписка,
		|	Продукция.НомерСтроки КАК НомерСтроки,
		|	Продукция.Номенклатура КАК НоменклатураПродукции,
		|	Продукция.Спецификация КАК Спецификация,
		|	Продукция.Количество КАК КоличествоПродукции
		|ПОМЕСТИТЬ Выпуск
		|ИЗ
		|	&Продукция КАК Продукция");
	
	// Данные о расходе сырья
	ТекстыЗапроса.Добавить(УправлениеПроизводством.ТекстЗапросаВременнаяТаблицаЗатратыСырья());
	
	// Преобразуем в формат получателя
	ТекстыЗапроса.Добавить(
		"ВЫБРАТЬ
		|	МАКСИМУМ(ЗатратыСырья.НомерСтрокиСпецификации) КАК НомерСтрокиСпецификации,
		|	МИНИМУМ(ЗатратыСырья.НомерСписка) КАК НомерСписка,
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.МатериалыПереданныеВПереработку) КАК СчетУчета,
		|	ЗатратыСырья.Номенклатура КАК Номенклатура,
		|	ЗатратыСырья.Номенклатура.Наименование КАК НоменклатураПредставление,
		|	СУММА(ЗатратыСырья.Количество) КАК Количество,
		|	ЗатратыСырья.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ЗатратыСырья.СтатьяЗатрат КАК СтатьяЗатрат
		|ИЗ
		|	ЗатратыСырья КАК ЗатратыСырья
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗатратыСырья.Номенклатура,
		|	ЗатратыСырья.Номенклатура.Наименование,
		|	ЗатратыСырья.ЕдиницаИзмерения,
		|	ЗатратыСырья.СтатьяЗатрат
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСписка,
		|	НомерСтрокиСпецификации,
		|	НоменклатураПредставление");
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("Продукция", Продукция.Выгрузить());
	Запрос.Текст = СтрСоединить(ТекстыЗапроса, ОбщегоНазначения.РазделительПакетаЗапросов());
	
	Материалы.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

// Процедура заполняет табличную часть остатками по складу
//
Процедура ЗаполнитьМатериалыПоОстаткам(ДатаДокумента) Экспорт 

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Субконто2 КАК Номенклатура,
		|	ХозрасчетныйОстатки.КоличествоОстаток КАК Количество,
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.МатериалыПереданныеВПереработку) КАК СчетУчета,
		|	ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.СписаниеМатериалов) КАК СтатьяЗатрат
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(&Период, Счет = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.МатериалыПереданныеВПереработку), , Субконто1 = &Контрагент) КАК ХозрасчетныйОстатки";
	Запрос.УстановитьПараметр("Период", ДатаДокумента);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	РезультатЗапроса = Запрос.Выполнить();
	Материалы.Загрузить(РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // ЗаполнитьМатериалыПоОстаткам()

// Процедура выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
		|	ТаблицаДокумента.Номенклатура,
		|	ТаблицаДокумента.СчетУчета
		|ПОМЕСТИТЬ ТаблицаДокумента
		|ИЗ
		|	&ТаблицаДокумента КАК ТаблицаДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ТаблицаДокумента1.НомерСтроки) КАК НомерСтроки,
		|	ТаблицаДокумента1.Номенклатура
		|ИЗ
		|	ТаблицаДокумента КАК ТаблицаДокумента1
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДокумента КАК ТаблицаДокумента2
		|		ПО ТаблицаДокумента1.НомерСтроки <> ТаблицаДокумента2.НомерСтроки
		|			И ТаблицаДокумента1.Номенклатура = ТаблицаДокумента2.Номенклатура
		|			И ТаблицаДокумента1.СчетУчета = ТаблицаДокумента2.СчетУчета
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаДокумента1.Номенклатура
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	Запрос.УстановитьПараметр("ТаблицаДокумента", Продукция);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Дубли строк.
	Если НЕ МассивРезультатов[1].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Номенклатура указывается повторно в строке %1 списка ""Продукция"".'"), 
							ВыборкаИзРезультатаЗапроса.НомерСтроки);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Продукция",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"Номенклатура",
				Отказ);
		КонецЦикла;
	КонецЕсли;		

	// Проверка ставок НСП
	Если Дата >= Дата(2022,01,01) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Услуги.ЗначениеСтавкиНСП КАК ЗначениеСтавкиНСП
		|ПОМЕСТИТЬ ВременнаяТаблицаУслуги
		|ИЗ
		|	&Услуги КАК Услуги
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВременнаяТаблицаУслуги.ЗначениеСтавкиНСП КАК ЗначениеСтавкиНСП
		|ИЗ
		|	ВременнаяТаблицаУслуги КАК ВременнаяТаблицаУслуги";
		
		Запрос.УстановитьПараметр("Услуги", Услуги);
		
		РезультатЗапроса = Запрос.Выполнить();
				
		// Услуги
		Если НЕ РезультатЗапроса.Пустой() И РезультатЗапроса.Выбрать().Количество() >= 2 Тогда
			ТекстСообщения = НСтр("ru = 'На закладке ""Услуги"" значения ставок НСП должны быть одинаковыми.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,, "Объект.Услуги", Отказ);	
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
	
#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
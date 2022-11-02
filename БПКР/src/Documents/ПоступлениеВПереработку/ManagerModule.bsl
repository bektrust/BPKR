#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ТекстЗапросаДанныеДляОбновленияЦенДокументов() Экспорт
	
	ТекстЗапроса = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
		|	ТаблицаДокумента.Цена КАК Цена,
		|	&Валюта КАК Валюта,
		|	&СпособЗаполненияЦены КАК СпособЗаполненияЦены,
		|	&ЦенаВключаетНалоги КАК ЦенаВключаетНалоги
		|ПОМЕСТИТЬ ТаблицаНоменклатуры
		|ИЗ
		|	Документ.ПоступлениеВПереработку.Товары КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса;
	
КонецФункции
 
// СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла 
 
// Устанавливает параметры загрузки.
//
//@skip-warning
Процедура УстановитьПараметрыЗагрузкиИзФайлаВТЧ(Параметры) Экспорт
	
КонецПроцедуры

// Производит сопоставление данных, загружаемых в табличную часть ПолноеИмяТабличнойЧасти,
// с данными в ИБ, и заполняет параметры АдресТаблицыСопоставления и СписокНеоднозначностей.
//
// Параметры:
//   АдресЗагружаемыхДанных    - Строка - Адрес временного хранилища с таблицей значений, в которой
//                                        находятся загруженные данные из файла. Состав колонок:
//     * Идентификатор - Число - Порядковый номер строки;
//     * остальные колонки соответствуют колонкам макета ЗагрузкаИзФайла.
//   АдресТаблицыСопоставления - Строка - Адрес временного хранилища с пустой таблицей значений,
//                                        являющейся копией табличной части документа, 
//                                        которую необходимо заполнить из таблицы АдресЗагружаемыхДанных.
//   СписокНеоднозначностей - ТаблицаЗначений - Список неоднозначных значений, для которых в ИБ имеется несколько
//                                              подходящих вариантов.
//     * Колонка       - Строка - Имя колонки, в которой была обнаружена неоднозначность;
//     * Идентификатор - Число  - Идентификатор строки, в которой была обнаружена неоднозначность.
//   ПолноеИмяТабличнойЧасти   - Строка - Полное имя табличной части, в которую загружаются данные.
//   ДополнительныеПараметры   - ЛюбойТип - Любые дополнительные сведения.
//
Процедура СопоставитьЗагружаемыеДанные(АдресЗагружаемыхДанных, АдресТаблицыСопоставления, СписокНеоднозначностей, ПолноеИмяТабличнойЧасти, ДополнительныеПараметры) Экспорт
	
	Товары = ПолучитьИзВременногоХранилища(АдресТаблицыСопоставления);
	ЗагружаемыеДанные = ПолучитьИзВременногоХранилища(АдресЗагружаемыхДанных);
	
	ТаблицаНоменклатура = ЗагрузкаДанныхИзФайлаПереопределяемыйБП.СопоставитьНоменклатуруДоПервогоСовпадения(ЗагружаемыеДанные); 
	
	Для Каждого СтрокаТаблицы Из ЗагружаемыеДанные Цикл
		
		СтрокаТабличнойЧасти = Товары.Добавить();
		СтрокаТабличнойЧасти.Идентификатор = СтрокаТаблицы.Идентификатор;
		СтрокаТабличнойЧасти.Количество = СтрокаТаблицы.Количество;
		СтрокаТабличнойЧасти.Цена = СтрокаТаблицы.Цена;
		СтрокаТабличнойЧасти.Сумма = СтрокаТаблицы.Сумма;
				
		СтрокаНоменклатура = ТаблицаНоменклатура.Найти(СтрокаТаблицы.Идентификатор, "Идентификатор");
		Если СтрокаНоменклатура <> Неопределено Тогда 
			Если СтрокаНоменклатура.Количество = 1 Тогда 
				СтрокаТабличнойЧасти.Номенклатура = СтрокаНоменклатура.Ссылка;
			ИначеЕсли СтрокаНоменклатура.Количество > 1 Тогда
				ЗаписьОНеоднозначности = СписокНеоднозначностей.Добавить();
				ЗаписьОНеоднозначности.Идентификатор = СтрокаТаблицы.Идентификатор; 
				ЗаписьОНеоднозначности.Колонка = "Номенклатура";
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(Товары, АдресТаблицыСопоставления);
	
КонецПроцедуры

// Возвращает список подходящих объектов ИБ для неоднозначного значения ячейки.
// 
// Параметры:
//   ПолноеИмяТабличнойЧасти  - Строка - Полное имя табличной части, в которую загружаются данные.
//  ИмяКолонки                - Строка - Имя колонки, в который возникла неоднозначность.
//  СписокНеоднозначностей    - Массив - Массив для заполнения с неоднозначными данными.
//  ЗагружаемыеЗначенияСтрока - Строка - Загружаемые данные на основании которых возникла неоднозначность.
//  ДополнительныеПараметры   - ЛюбойТип - Любые дополнительные сведения.
//
Процедура ЗаполнитьСписокНеоднозначностей(ПолноеИмяТабличнойЧасти, СписокНеоднозначностей, ИмяКолонки, ЗагружаемыеЗначенияСтрока, ДополнительныеПараметры) Экспорт
	
	Если ИмяКолонки = "Номенклатура" Тогда

		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Номенклатура.Ссылка
			|ИЗ
			|	Справочник.Номенклатура КАК Номенклатура
			|ГДЕ
			|	Номенклатура.Наименование = &Наименование";
		Запрос.УстановитьПараметр("Наименование", ЗагружаемыеЗначенияСтрока.Номенклатура);
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			СписокНеоднозначностей.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла
 
#КонецОбласти

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	// Подготовка данных ТМЗ
	// 1. Таблица Реквизиты
	// 2. Таблица Товары
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Ссылка КАК Регистратор,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Склад КАК Склад,
		|	ВременнаяТаблицаШапка.Контрагент КАК Контрагент,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаВзаиморасчетов
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаТовары.НомерСтроки КАК НомерСтроки,
		|	ВременнаяТаблицаТовары.СчетУчета КАК СчетУчета,
		|	ВременнаяТаблицаТовары.Номенклатура КАК Номенклатура,
		|	ВременнаяТаблицаТовары.Сумма КАК Сумма,
		|	ВременнаяТаблицаТовары.Сумма КАК СуммаВзаиморасчетов,
		|	ВременнаяТаблицаТовары.Количество КАК Количество,
		|	НЕОПРЕДЕЛЕНО КАК КорСчет,
		|	ВременнаяТаблицаШапка.Контрагент КАК КорСубконто1,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента КАК КорСубконто2,
		|	НЕОПРЕДЕЛЕНО КАК КорСубконто3,
		|	0 КАК СуммаАкциза,
		|	&СодержаниеВПереработку КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|		ПО (ИСТИНА)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	Запрос.УстановитьПараметр("СодержаниеВПереработку", НСтр("ru = 'Поступление материалов в переработку'"));
	МассивРезультатов = Запрос.ВыполнитьПакет();

	ТаблицаРеквизиты = МассивРезультатов[0].Выгрузить();
	ТаблицаМатериалыВПереработку = МассивРезультатов[1].Выгрузить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРеквизиты", ТаблицаРеквизиты);
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаМатериалыВПереработку", ТаблицаМатериалыВПереработку);
	
КонецПроцедуры

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц 	= СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка КАК Ссылка,
		|	ТаблицаДокумента.Дата КАК Дата,
		|	ТаблицаДокумента.Номер КАК Номер,
		|	ТаблицаДокумента.Организация КАК Организация,
		|	ТаблицаДокумента.ВалютаДокумента КАК ВалютаДокумента,
		|	ТаблицаДокумента.Склад КАК Склад,
		|	ТаблицаДокумента.Контрагент КАК Контрагент,
		|	ТаблицаДокумента.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	ТаблицаДокумента.СуммаДокумента КАК СуммаДокумента
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.ПоступлениеВПереработку КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &ДокументСсылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
		|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
		|	ТаблицаДокумента.Количество КАК Количество,
		|	ТаблицаДокумента.Цена КАК Цена,
		|	ТаблицаДокумента.Сумма КАК Сумма,
		|	ТаблицаДокумента.СчетУчета КАК СчетУчета
		|ПОМЕСТИТЬ ВременнаяТаблицаТовары
		|ИЗ
		|	Документ.ПоступлениеВПереработку.Товары КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &ДокументСсылка";
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	Запрос.Выполнить();    		
		
	СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства);	
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

// Функция формирует табличный документ с печатной формой ПечатьНакладной
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьНакладная(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ПоступлениеВПереработку.Ссылка,
		|	ПоступлениеВПереработку.Номер,
		|	ПоступлениеВПереработку.Дата,
		|	ПоступлениеВПереработку.Организация,
		|	ПоступлениеВПереработку.Склад,
		|	ПоступлениеВПереработку.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	ПоступлениеВПереработку.Контрагент.НаименованиеПолное КАК КонтрагентНаименованиеПолное,
		|	ПРЕДСТАВЛЕНИЕ(ПоступлениеВПереработку.Склад) КАК СкладПредставление,
		|	ПоступлениеВПереработку.ВалютаДокумента,
		|	ПоступлениеВПереработку.Товары.(
		|		НомерСтроки,
		|		Номенклатура,
		|		Номенклатура.НаименованиеПолное КАК НоменклатураПредставление,
		|		ПРЕДСТАВЛЕНИЕ(Номенклатура.КодТНВЭД) КАК КодПоКлассификатору,
		|		ПРЕДСТАВЛЕНИЕ(ПоступлениеВПереработку.Товары.Номенклатура.ЕдиницаИзмерения) КАК ЕИ,
		|		Количество,
		|		Цена,
		|		Сумма
		|	)
		|ИЗ
		|	Документ.ПоступлениеВПереработку КАК ПоступлениеВПереработку
		|ГДЕ
		|	ПоступлениеВПереработку.Ссылка В(&СписокДокументов)";		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПоступлениеВПереработку_Накладная";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПоступлениеВПереработку.ПФ_MXL_Накладная");
	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;
		
		ТекстЗаголовка = СформироватьЗаголовокДокумента(Шапка, НСтр("ru = 'Накладная на поступление'"));
		ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		ДанныеПечати.Вставить("ОрганизацияНаименованиеПолное", Шапка.ОрганизацияНаименованиеПолное);
		ДанныеПечати.Вставить("СкладПредставление", Шапка.СкладПредставление);
		ДанныеПечати.Вставить("КонтрагентНаименованиеПолное", Шапка.КонтрагентНаименованиеПолное);

		ТаблицаТовары = Шапка.Товары.Выгрузить();
		
		Сумма = ТаблицаТовары.Итог("Сумма");
		КоличествоНаименований = ТаблицаТовары.Количество();		
		
		ДанныеПечати.Вставить("Сумма", Сумма);
		ДанныеПечати.Вставить("ИтоговаяСтрока", 
			СтрШаблон(НСтр("ru = 'Всего наименований %1, на сумму %2'"), 
			Формат(КоличествоНаименований, "ЧН=0; ЧГ=0"), Формат(ДанныеПечати.Сумма, "ЧЦ=15; ЧДЦ=2")));
		ДанныеПечати.Вставить("СуммаПрописью", 
								БухгалтерскийУчетСервер.СформироватьСуммуПрописью(
									ДанныеПечати.Сумма, 
									ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета()));

		// Области
		МассивОбластейМакета = Новый Массив;
		МассивОбластейМакета.Добавить("Заголовок");
		МассивОбластейМакета.Добавить("ШапкаТаблицы");
		МассивОбластейМакета.Добавить("Строка");
		МассивОбластейМакета.Добавить("Подвал");
		МассивОбластейМакета.Добавить("Итоги");
		МассивОбластейМакета.Добавить("СуммаПрописью");
		МассивОбластейМакета.Добавить("Подписи");
	
		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			Если ИмяОбласти <> "Строка" Тогда
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			ИначеЕсли ИмяОбласти = "Строка" Тогда
				Для Каждого СтрокаТаблицы Из ТаблицаТовары Цикл
					ОбластьМакета.Параметры.Заполнить(СтрокаТаблицы);
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
			КонецЕсли;	
		КонецЦикла;
		
		БухгалтерскиеОтчеты.ВыводПодписиРуководителей(ТабличныйДокумент, Шапка);
		
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Накладная") Тогда
		 // Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"Накладная",  НСтр("ru = 'Накладная'"), ПечатьНакладная(МассивОбъектов, ОбъектыПечати, ПараметрыПечати),,
			"Документ.ПоступлениеВПереработку.ПФ_MXL_Накладная");
	КонецЕсли;

КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
		
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Накладная";
	КомандаПечати.Представление = НСтр("ru = 'Накладная'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "РеестрПоступлениеВПереработку";
	КомандаПечати.Представление  = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Реестр документов ""Поступление в переработку""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает заголовок документа для печатной формы.
//
// Параметры:
//  Шапка - любая структура с полями:
//           Номер         - Строка или Число - номер документа;
//           Дата          - Дата - дата документа;
//           Представление - Строка - (необязательный) платформенное представление ссылки на документ.
//                                    Если параметр НазваниеДокумента не задан, то название документа будет вычисляться
//                                    из этого параметра.
//  НазваниеДокумента - Строка - название документа (например, "Счет на оплату").
//
// Возвращаемое значение:
//  Строка - заголовок документа.
//
Функция СформироватьЗаголовокДокумента(Шапка, Знач НазваниеДокумента = "")
	
	ДанныеДокумента = Новый Структура("Номер,Дата,Представление");
	ЗаполнитьЗначенияСвойств(ДанныеДокумента, Шапка);
	
	// Если название документа не передано, получим название по представлению документа.
	Если ПустаяСтрока(НазваниеДокумента) И ЗначениеЗаполнено(ДанныеДокумента.Представление) Тогда
		ПоложениеНомера = СтрНайти(ДанныеДокумента.Представление, ДанныеДокумента.Номер);
		Если ПоложениеНомера > 0 Тогда
			НазваниеДокумента = СокрЛП(Лев(ДанныеДокумента.Представление, ПоложениеНомера - 1));
		КонецЕсли;
	КонецЕсли;

	НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокумента.Номер);
	Возврат СтрШаблон(НСтр("ru = '%1 № %2 от %3'"),
		НазваниеДокумента, НомерНаПечать, Формат(ДанныеДокумента.Дата, "ДЛФ=DD"));
	
КонецФункции

#КонецОбласти

#КонецЕсли

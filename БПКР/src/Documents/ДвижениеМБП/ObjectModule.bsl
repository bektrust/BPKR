#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ЗаполненияДокумента

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - ДокументСсылка.ПоступлениеТоваровУслуг - Данные заполнения документа.
//	
Процедура ЗаполнитьПоПоступлениюТоваров(ДанныеЗаполнения) Экспорт
	ДокументОснование = ДанныеЗаполнения;
	
	Организация = ДанныеЗаполнения.Организация;
	Склад = ДанныеЗаполнения.Склад;
	ВидОперации = Перечисления.ВидыОперацийДвижениеМБП.ВводМБПВЭксплуатацию;
	
	СчетаУчетаМБП = БухгалтерскийУчетСервер.СчетаУчетаМБП();
	
	Для Каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.Товары Цикл
		Если СчетаУчетаМБП.Найти(СтрокаТабличнойЧасти.СчетУчета) <> Неопределено Тогда
			НоваяСтрока = Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТабличнойЧасти);
		КонецЕсли;	
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.ПоступлениеТоваровУслуг")] = "ЗаполнитьПоПоступлениюТоваров";
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
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
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ВидУчетаИзносаМБП = БухгалтерскийУчетСервер.ПолучитьДанныеУчетнойПолитикиОрганизаций(Дата, Организация).ВидУчетаИзносаМБП;
	
	Если Товары.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Закладка ""МБП"" должна быть заполнена.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,,Отказ);	
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ВидОперации = Перечисления.ВидыОперацийДвижениеМБП.ВводМБПВЭксплуатацию Тогда  
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицо");
		МассивНепроверяемыхРеквизитов.Добавить("СкладПолучатель");
		Если ВидУчетаИзносаМБП = Перечисления.ВидыУчетаИзносаМБП.ПриСписании Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетЗатрат");	
		КонецЕсли;
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийДвижениеМБП.ПеремещениеМБП Тогда		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетЗатрат");
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
		МассивНепроверяемыхРеквизитов.Добавить("СкладПолучатель");
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийДвижениеМБП.ПеремещениеМБППоСкладам Тогда		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетЗатрат");
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицоПолучатель");
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицо");
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийДвижениеМБП.СписаниеМБП Тогда		
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицоПолучатель");
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
		МассивНепроверяемыхРеквизитов.Добавить("СкладПолучатель");

		Если ВидУчетаИзносаМБП = Перечисления.ВидыУчетаИзносаМБП.ПриВводе Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетЗатрат");	
		КонецЕсли;
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийДвижениеМБП.РеализацияМБП Тогда  
		МассивНепроверяемыхРеквизитов.Добавить("ФизЛицоПолучатель");
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
		МассивНепроверяемыхРеквизитов.Добавить("СкладПолучатель");

		Если ВидУчетаИзносаМБП = Перечисления.ВидыУчетаИзносаМБП.ПриВводе Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетЗатрат");	
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
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
	Документы.ДвижениеМБП.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
КонецПроцедуры
	
// Процедура заполняет регистры данными
//
Процедура ОтразитьДвижения(Отказ, РежимПроведения)

	// Отражение в разделах учета.
	ВидУчетаИзносаМБП = ДополнительныеСвойства.УчетнаяПолитика.ВидУчетаИзносаМБП;
		
	Если ВидОперации = Перечисления.ВидыОперацийДвижениеМБП.ВводМБПВЭксплуатацию Тогда
		Если ВидУчетаИзносаМБП = Перечисления.ВидыУчетаИзносаМБП.ПриВводе Тогда
			УчетМБП.СформироватьДвиженияПеремещениеМБП(ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаСписанныеМБП, 
		ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизиты, Движения, Отказ, Истина);
		Иначе
			УчетМБП.СформироватьДвиженияПеремещениеМБП(ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаСписанныеМБП, 
		ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизиты, Движения, Отказ);
		КонецЕсли;
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийДвижениеМБП.ПеремещениеМБП
		Или ВидОперации = Перечисления.ВидыОперацийДвижениеМБП.ПеремещениеМБППоСкладам Тогда
		УчетМБП.СформироватьДвиженияПеремещениеМБП(ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаСписанныеМБП, 
		ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизиты, Движения, Отказ);
		
	Иначе
		Если ВидУчетаИзносаМБП = Перечисления.ВидыУчетаИзносаМБП.ПриСписании Тогда
			УчетМБП.СформироватьДвиженияСписаниеМБПВЭксплуатации(ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаСписанныеМБП, 
		ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизиты, Движения, Отказ, Истина);
		Иначе
			УчетМБП.СформироватьДвиженияСписаниеМБПВЭксплуатации(ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаСписанныеМБП, 
		ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизиты, Движения, Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
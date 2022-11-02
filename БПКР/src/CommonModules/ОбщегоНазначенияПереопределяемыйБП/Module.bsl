///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// См. ОбщегоНазначенияПереопределяемый.ПриОпределенииОбщихПараметровБазовойФункциональности.
Процедура ПриОпределенииОбщихПараметровБазовойФункциональности(ОбщиеПараметры) Экспорт
	
	ОбщиеПараметры.Вставить("РекомендуемаяВерсияПлатформы", "8.3.20.1789");
	ОбщиеПараметры.РекомендуемыйОбъемОперативнойПамяти = 3;
	ОбщиеПараметры.Вставить("ИмяФормыПерсональныхНастроек", "ОбщаяФорма.ПерсональныеНастройки");
	
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииОбработчиковУстановкиПараметровСеанса.
Процедура ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики) Экспорт
	Обработчики.Вставить("РазрешенныеПользователюРазделыПерсонализированныхДанных" , "ПерсонализированныеПредложенияСервисов.УстановитьРазрешенныеПользователюРазделыПерсонализированныхДанных");
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиентаПриЗапуске.
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	//Если НЕ Параметры.Свойство("ЗаголовокПриложения") Тогда 
	//	Параметры.Вставить("ЗаголовокПриложения", "");
	//КонецЕсли;	
	//	
	//ОсновнаяОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	//ПредставлениеЗаголовка = ?(ЗначениеЗаполнено(ОсновнаяОрганизация), ОсновнаяОрганизация.Наименование, "");
	//Параметры.ЗаголовокПриложения = ПредставлениеЗаголовка;
	
	// НачалоРаботыСПрограммой
	НачалоРаботыСПрограммойСервер.ПараметрыРаботыКлиентаПриЗапуске(Параметры);
	// Конец НачалоРаботыСПрограммой

	// Информация о необходимости обновить конфигурацию
	Параметры.Вставить("ПоказатьПредложитьОбновитьВерсиюПрограммы", ОбщегоНазначенияБПСервер.ПредлагатьОбновитьВерсиюПрограммы(Параметры));

	ДатаПервогоВходаВСистемуЗаполнена = ЗначениеЗаполнено(Константы.ДатаПервогоВходаВСистему.Получить());
	
	// ЗнакомствоСРедакциейВ30
	Если НЕ ДатаПервогоВходаВСистемуЗаполнена Тогда
		ПоказатьЗнакомствоСРедакциейВ30 = Ложь;
	Иначе	
		ПоказатьЗнакомствоСРедакциейВ30 = ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных()
			И ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НачалоРаботыВ30", "Показывать", Истина);
	КонецЕсли;
	
	Если ПоказатьЗнакомствоСРедакциейВ30 Тогда
		ИмяОбработкиЗнакомствоСРедакциейВ30 = "НачинаемРаботатьВ30";
			
		Если Не ПравоДоступа("Использование", Метаданные.Обработки[ИмяОбработкиЗнакомствоСРедакциейВ30]) Тогда
			ПоказатьЗнакомствоСРедакциейВ30 = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Параметры.Вставить("ПоказатьЗнакомствоСРедакциейВ30",     ПоказатьЗнакомствоСРедакциейВ30);
	Параметры.Вставить("ИмяОбработкиЗнакомствоСРедакциейВ30", ИмяОбработкиЗнакомствоСРедакциейВ30);
	// Конец ЗнакомствоСРедакциейВ30
	
	// ПечатьПараметровУчета
	Если НЕ ДатаПервогоВходаВСистемуЗаполнена ИЛИ НЕ ПравоДоступа("Изменение", Метаданные.Справочники.Организации) Тогда  
		ПоказатьПечатьПараметровУчета = Ложь;
	Иначе
		ПоказатьПечатьПараметровУчета = ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных()
			И ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПечатьПараметровУчета", "Показывать", Истина);
	КонецЕсли;
	
	Если ПоказатьПечатьПараметровУчета Тогда
		ИмяОбработкиПечатьПараметровУчета = "ПечатьПараметровУчета";
			
		Если Не ПравоДоступа("Использование", Метаданные.Обработки[ИмяОбработкиПечатьПараметровУчета]) Тогда
			ПоказатьПечатьПараметровУчета = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Параметры.Вставить("ПоказатьПечатьПараметровУчета",     ПоказатьПечатьПараметровУчета);
	Параметры.Вставить("ИмяОбработкиПечатьПараметровУчета", ИмяОбработкиПечатьПараметровУчета);
	// Конец ПечатьПараметровУчета
	
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПриОпределенииПараметровФункциональныхОпцийИнтерфейса.
Процедура ПриОпределенииПараметровФункциональныхОпцийИнтерфейса(ОпцииИнтерфейса) Экспорт
	ОпцииИнтерфейса.Вставить("Организация", Справочники.Организации.ОрганизацияПоУмолчанию());
КонецПроцедуры

#КонецОбласти

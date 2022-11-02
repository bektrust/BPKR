///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// См. ОбменДаннымиПереопределяемый.ПриОпределенииПрефиксаИнформационнойБазыПоУмолчанию.
Процедура ПриОпределенииПрефиксаИнформационнойБазыПоУмолчанию(Префикс) Экспорт
	
	// БПКР
	Префикс = НСтр("ru = 'БП'");
	// Конец БПКР
	
КонецПроцедуры

// См. ОбменДаннымиПереопределяемый.ПолучитьПланыОбмена.
Процедура ПолучитьПланыОбмена(ПланыОбменаПодсистемы) Экспорт
	
	ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.АвтономнаяРабота);
	ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.Полный);
	ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.ПоОрганизации);
	ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат);
	
КонецПроцедуры

// См. ОбменДаннымиПереопределяемый.ПриПолученииДоступныхВерсийФормата.
Процедура ПриПолученииДоступныхВерсийФормата(ВерсииФормата) Экспорт
	
	//ВерсииФормата.Вставить("1.2", МенеджерОбменаЧерезУниверсальныйФормат);
	//ВерсииФормата.Вставить("1.3", МенеджерОбменаЧерезУниверсальныйФормат);
	//ВерсииФормата.Вставить("1.4", МенеджерОбменаЧерезУниверсальныйФормат);
	//ВерсииФормата.Вставить("1.5", МенеджерОбменаЧерезУниверсальныйФормат);
	//ВерсииФормата.Вставить("1.6", МенеджерОбменаЧерезУниверсальныйФормат);
	//ВерсииФормата.Вставить("1.7", МенеджерОбменаЧерезУниверсальныйФормат);
	ВерсииФормата.Вставить("1.8", МенеджерОбменаЧерезУниверсальныйФормат);
	
КонецПроцедуры

#КонецОбласти

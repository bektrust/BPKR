///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриОпределенииНастроек
// 
// Параметры:
//   Параметры - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриОпределенииНастроек.Параметры
//
Процедура ПриОпределенииНастроек(Параметры) Экспорт
	
	Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.Организации);
	Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.Валюты);
	Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.Кассы);
	Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.ГНС);
	Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.СтатьиДвиженияДенежныхСредств);
	Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.ТипыЦенНоменклатуры);
	//Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.КодыПоставокНДС);
	
	// Основные средства.
	Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.ГруппыИмущества);
	Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.СпособыОтраженияРасходовПоАмортизации);
	
	// Заработная плата.
	Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.ГрафикиРаботы);
	Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.МетодыРасчетаОтпуска);
	Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.Статусы);
	Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.СпособыОтраженияЗаработнойПлаты);
	//Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.СтрокиОтчетаПН);
	Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.СтатьиТрудовогоКодекса);
	
	Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.СостояниеВБраке);
	Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.СтепениЗнанияЯзыка);
	Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.УченыеЗвания);
	Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.УченыеСтепени);
	Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.Города);
	
	// Прочее.
	Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.КлассификаторЕдиницИзмерения);
	Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.СтраныМира);
	Параметры.ОбъектыСНачальнымЗаполнением.Добавить(Метаданные.Справочники.ЗадачиБухгалтера);

КонецПроцедуры

#КонецОбласти

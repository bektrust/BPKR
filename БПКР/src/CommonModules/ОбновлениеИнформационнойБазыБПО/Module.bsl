///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Сведения о библиотеке (или конфигурации).

#Область ПрограммныйИнтерфейс

// Заполняет основные сведения о библиотеке или основной конфигурации.
// Библиотека, имя которой имя совпадает с именем конфигурации в метаданных, определяется как основная конфигурация.
// 
// Параметры:
//  Описание - Структура - сведения о библиотеке:
//
//   * Имя                 - Строка - имя библиотеки, например, "СтандартныеПодсистемы".
//   * Версия              - Строка - версия в формате из 4-х цифр, например, "2.1.3.1".
//
//   * ТребуемыеПодсистемы - Массив - имена других библиотек (Строка), от которых зависит данная библиотека.
//                                    Обработчики обновления таких библиотек должны быть вызваны ранее
//                                    обработчиков обновления данной библиотеки.
//                                    При циклических зависимостях или, напротив, отсутствии каких-либо зависимостей,
//                                    порядок вызова обработчиков обновления определяется порядком добавления модулей
//                                    в процедуре ПриДобавленииПодсистем общего модуля
//                                    ПодсистемыКонфигурацииПереопределяемый.
//
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя    = "БиблиотекаПодключаемогоОборудованияДляКыргызстана";
	Описание.Версия = МенеджерОборудования.ВерсияБиблиотеки();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления информационной базы.

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - описание полей, см. в процедуре.
//                ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления.
//
// Пример:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.1.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_1_0_0";
//  Обработчик.РежимВыполнения     = "Монопольно".
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "*";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.РежимВыполнения = "Оперативно";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыБПО.ОбновитьПоставляемыеДрайвера";
	Обработчик.Комментарий = НСтр("ru = 'Обновление поставляемых драйверов подключаемого оборудования.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = МенеджерОборудования.ВерсияБиблиотеки();
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.РежимВыполнения = "Оперативно";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыБПО.ОбновитьПоставляемыеДрайвера";
	Обработчик.Комментарий = НСтр("ru = 'Обновление поставляемых драйверов подключаемого оборудования.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "*";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.РежимВыполнения = "Оперативно";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыБПО.ОбновитьСправочникДрайвера";
	Обработчик.Комментарий = НСтр("ru = 'Обновление справочника драйверов подключаемого оборудования.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = МенеджерОборудования.ВерсияБиблиотеки();
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.РежимВыполнения =  "Оперативно";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыБПО.ОбновитьПодключаемоеОборудование";
	Обработчик.Комментарий = НСтр("ru = 'Обновление оборудования ККМ-офлайн.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "*";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.РежимВыполнения = "Оперативно";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыБПО.ОбновитьШаблоныЭтикетокИЦенников";
	Обработчик.Комментарий = НСтр("ru = 'Создание предопределенных шаблонов печати.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.1.2.19";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.РежимВыполнения = "Оперативно";
	Обработчик.Процедура = "РегистрыСведений.ЗначенияЕМРЦ.ЗаполнитьЗначенияРегистраЕМРЦ";
	Обработчик.Комментарий = НСтр("ru = 'Создание предопределенных шаблонов печати.'");
	
КонецПроцедуры

// Вызывается перед процедурами-обработчиками обновления данных ИБ.
//
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
КонецПроцедуры

// Вызывается после завершения обновления данных ИБ.
// 
// Параметры:
//   ПредыдущаяВерсия       - Строка - версия до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсия          - Строка - версия после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков обновления,
//                                             сгруппированных по номеру версии.
//   ВыводитьОписаниеОбновлений - Булево - если установить Истина, то будет выведена форма
//                                с описанием обновлений. По умолчанию, Истина.
//                                Возвращаемое значение.
//   МонопольныйРежим           - Булево - Истина, если обновление выполнялось в монопольном режиме.
//
// Пример:
//  // Пример обхода выполненных обработчиков обновления:
//	Для Каждого Версия Из ВыполненныеОбработчики.Строки Цикл
//		
//		Если Версия.Версия = "*" Тогда
//			// Обработчик, который может выполнятся при каждой смене версии.
//		Иначе
//			// Обработчик, который выполняется для определенной версии.
//		КонецЕсли;
//		
//		Для Каждого Обработчик Из Версия.Строки Цикл
//			...
//		КонецЦикла;
//		
//	КонецЦикла;
//
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
	
КонецПроцедуры

// Вызывается при подготовке табличного документа с описанием изменений в программе.
//
// Параметры:
//   Макет - ТабличныйДокумент - описание обновления всех библиотек и конфигурации.
//           Макет можно дополнить или заменить.
//           См. также общий макет ОписаниеИзмененийСистемы.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
КонецПроцедуры

// Позволяет переопределить режим обновления данных информационной базы.
// Для использования в редких (нештатных) случаях перехода, не предусмотренных в
// стандартной процедуре определения режима обновления.
//
// Параметры:
//   РежимОбновленияДанных - Строка - в обработчике можно присвоить одно из значений:
//              "НачальноеЗаполнение"     - если это первый запуск пустой базы (области данных);
//              "ОбновлениеВерсии"        - если выполняется первый запуск после обновление конфигурации базы данных;
//              "ПереходСДругойПрограммы" - если выполняется первый запуск после обновление конфигурации базы данных, 
//                                          в которой изменилось имя основной конфигурации.
//
//   СтандартнаяОбработка  - Булево - если присвоить Ложь, то стандартная процедура
//                                    определения режима обновления не выполняется, 
//                                    а используется значение РежимОбновленияДанных.
//
Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт
 
КонецПроцедуры

// Добавляет в список процедуры-обработчики перехода с другой программы (с другим именем конфигурации).
// Например, для перехода между разными, но родственными конфигурациями: базовая -> проф -> корп.
// Вызывается перед началом обновления данных ИБ.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - с колонками:
//    * ПредыдущееИмяКонфигурации - Строка - имя конфигурации, с которой выполняется переход;
//                                           или "*", если нужно выполнять при переходе с любой конфигурации.
//    * Процедура                 - Строка - полное имя процедуры-обработчика перехода с программы ПредыдущееИмяКонфигурации. 
//                                  Например, "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику"
//                                  Обязательно должна быть экспортной.
//
// Пример:
//  // Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.ПредыдущееИмяКонфигурации  = "УправлениеТорговлей";
//  Обработчик.Процедура                  = "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику".
//
Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
 
КонецПроцедуры

// Вызывается после выполнения всех процедур-обработчиков перехода с другой программы (с другим именем конфигурации),
// и до начала выполнения обновления данных ИБ.
//
// Параметры:
//  ПредыдущееИмяКонфигурации    - Строка - имя конфигурации до перехода.
//  ПредыдущаяВерсияКонфигурации - Строка - имя предыдущей конфигурации (до перехода).
//  Параметры                    - Структура - 
//    * ВыполнитьОбновлениеСВерсии   - Булево - по умолчанию Истина. Если установить Ложь, 
//        то будут выполнена только обязательные обработчики обновления (с версией "*").
//    * ВерсияКонфигурации           - Строка - номер версии после перехода. 
//        По умолчанию, равен значению версии конфигурации в свойствах метаданных.
//        Для того чтобы выполнить, например, все обработчики обновления с версии ПредыдущаяВерсияКонфигурации, 
//        следует установить значение параметра в ПредыдущаяВерсияКонфигурации.
//        Для того чтобы выполнить вообще все обработчики обновления, установить значение "0.0.0.1".
//    * ОчиститьСведенияОПредыдущейКонфигурации - Булево - по умолчанию Истина. 
//        Для случаев когда предыдущая конфигурация совпадает по имени с подсистемой текущей конфигурации, следует указать Ложь.
//
Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации, Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт
 
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ПроцедурыОбновления
// АПК:1327-выкл процедуры выполняются в монопольном режиме, #std490 п 2.
// АПК:1328-выкл процедуры выполняются в монопольном режиме, #std490 п 2.

// Обновить поставляемые драйвера БПО.
//
Процедура ОбновитьПоставляемыеДрайвера(Параметры = Неопределено) Экспорт
	
	МенеджерОборудования.ОбновитьПоставляемыеДрайвера();
	МенеджерОборудования.ОбновитьУстановленныеДрайвера();
	
КонецПроцедуры

Процедура ОбновитьСправочникДрайвера(Параметры = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДрайверыОборудования.Ссылка КАК Ссылка,
		|	ДрайверыОборудования.УдалитьИмяФайлаДрайвера КАК УдалитьИмяФайлаДрайвера,
		|	ДрайверыОборудования.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных,
		|	ДрайверыОборудования.ИдентификаторОбъекта КАК ИдентификаторОбъекта
		|ИЗ
		|	Справочник.ДрайверыОборудования КАК ДрайверыОборудования";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.ИдентификаторОбъекта = "ОнлайнКасса" Тогда
			Продолжить;
		КонецЕсли;
		
		ДрайверОбъект = Выборка.Ссылка.ПолучитьОбъект();
		Если Не ПустаяСтрока(Выборка.ИмяПредопределенныхДанных) Тогда
			ДрайверОбъект.СпособПодключения = Перечисления.СпособПодключенияДрайвера.ИзМакета;
			ДрайверОбъект.Записать();
		Иначе
			Если ПустаяСтрока(ДрайверОбъект.СпособПодключения) Тогда
				Если ПустаяСтрока(Выборка.УдалитьИмяФайлаДрайвера) Тогда
					ДрайверОбъект.СпособПодключения = Перечисления.СпособПодключенияДрайвера.ЛокальноПоИдентификатору;
				Иначе
					ДрайверОбъект.СпособПодключения = Перечисления.СпособПодключенияДрайвера.ИзИнформационнойБазы;
				КонецЕсли;
			КонецЕсли;
			Если Лев(ДрайверОбъект.ИдентификаторОбъекта, 6) = "AddIn." Тогда
				ДрайверОбъект.ИдентификаторОбъекта = Прав(ДрайверОбъект.ИдентификаторОбъекта, СтрДлина(ДрайверОбъект.ИдентификаторОбъекта) - 6);
			КонецЕсли;
			ДрайверОбъект.Записать();
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДрайверыОборудования.Ссылка КАК Ссылка,
		|	ДрайверыОборудования.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных
		|ИЗ
		|	Справочник.ДрайверыОборудования КАК ДрайверыОборудования";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если СтрНачинаетсяС(Выборка.ИмяПредопределенныхДанных, "#") Тогда 
			ДрайверОбъект = Выборка.Ссылка.ПолучитьОбъект();			
			ДрайверОбъект.ИмяПредопределенныхДанных = "";
			ДрайверОбъект.Записать();
			ДрайверОбъект.УстановитьПометкуУдаления(Истина);
		КонецЕсли;	
	КонецЦикла;
КонецПроцедуры

// Обновить оборудование.
//
Процедура ОбновитьПодключаемоеОборудование(Параметры = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПодключаемоеОборудование.Ссылка КАК Ссылка,
		|	ПодключаемоеОборудование.ТипОборудования КАК ТипОборудования
		|ИЗ
		|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	ШаблонТекстаОшибки = НСтр("ru = 'Не удалось обработать обновление подключаемого оборудования по причине: %1'");
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			Если Выборка.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.УдалитьККМОфлайн Тогда
				
				ОбработатьОфлайнОборудование(Выборка.Ссылка);
				
			Иначе
				
				ОбработатьПодключаемоеОборудование(Выборка.Ссылка);
				
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстОшибки = СтрШаблон(ШаблонТекстаОшибки, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление информационной базы'",
				ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,,,
				ТекстОшибки);
			
		КонецПопытки;
		
	КонецЦикла;
	
	МодульМенеджерОфлайнОборудованияВызовСервераПереопределяемый = ОбщегоНазначения.ОбщийМодуль("МенеджерОфлайнОборудованияВызовСервераПереопределяемый");
	МодульМенеджерОфлайнОборудованияВызовСервераПереопределяемый.ДополнительнаяОбработкаОбъектовПриПереходеНаОфлайнОборудование();
	
КонецПроцедуры

// Обновить шаблоны этикеток и ценников БПО.
//
Процедура ОбновитьШаблоныЭтикетокИЦенников(Параметры = Неопределено) Экспорт    
	                                          
	Если МенеджерОборудованияВызовСервера.ИспользуетсяПечатьЭтикетокИЦенников() Тогда
		МодульПечатьЭтикетокИЦенниковБПО = ОбщегоНазначения.ОбщийМодуль("ПечатьЭтикетокИЦенниковБПО");
		МодульПечатьЭтикетокИЦенниковБПО.ЗаполнитьПредопределенныеЭлементы();
	КонецЕсли;
	
КонецПроцедуры

// АПК:1328-вкл
// АПК:1327-вкл

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// АПК:1327-выкл процедуры выполняются в монопольном режиме, #std490 п 2.
// АПК:1328-выкл процедуры выполняются в монопольном режиме, #std490 п 2.

Процедура ОбработатьПодключаемоеОборудование(СсылкаНаОборудование)
	
	ОборудованиеОбъект = СсылкаНаОборудование.ПолучитьОбъект();
	ОборудованиеОбъект.ТипПодключения = Перечисления.ТипыПодключенияОборудования.ЛокальноеПодключение;
	ОборудованиеОбъект.Записать();
	
	МенеджерОборудованияВызовСервераПереопределяемый.ОбновитьСправочникПодключаемогоОборудования(СсылкаНаОборудование);
	
КонецПроцедуры

// Обновить оборудование ККМ офлайн.
//
Процедура ОбработатьОфлайнОборудование(СсылкаНаПодключаемоеОборудование)
	
	ПодключаемоеОборудованиеОбъект = СсылкаНаПодключаемоеОборудование.ПолучитьОбъект();
	ПодключаемоеОборудованиеОбъект.ПометкаУдаления = Истина;
	ПодключаемоеОборудованиеОбъект.Записать();
	
	УИ = СсылкаНаПодключаемоеОборудование.УникальныйИдентификатор();
	
	СсылкаНаОфлайнОборудование = Справочники.ОфлайнОборудование.ПолучитьСсылку(УИ);
	
	ОбъектОфлайнОборудование = СсылкаНаОфлайнОборудование.ПолучитьОбъект();
	
	Если ОбъектОфлайнОборудование = Неопределено Тогда
		
		ОбъектОфлайнОборудование = Справочники.ОфлайнОборудование.СоздатьЭлемент();
		ОбъектОфлайнОборудование.УстановитьСсылкуНового(СсылкаНаОфлайнОборудование);
		
	КонецЕсли;
	
	ОбъектОфлайнОборудование.Организация = ПодключаемоеОборудованиеОбъект.Организация;
	ОбъектОфлайнОборудование.Наименование = ПодключаемоеОборудованиеОбъект.Наименование;
	ОбъектОфлайнОборудование.ТипОфлайнОборудования = ПодключаемоеОборудованиеОбъект.УдалитьТипОфлайнОборудования;
	Если Не ЗначениеЗаполнено(ОбъектОфлайнОборудование.ТипОфлайнОборудования) Тогда
		ОбъектОфлайнОборудование.ТипОфлайнОборудования = Перечисления.ТипыОфлайнОборудования.ККМ;
	КонецЕсли;
	ОбъектОфлайнОборудование.ВидТранспортаОфлайнОбмена = ПодключаемоеОборудованиеОбъект.УдалитьВидТранспортаОфлайнОбмена;
	Если Не ЗначениеЗаполнено(ОбъектОфлайнОборудование.ВидТранспортаОфлайнОбмена) Тогда
		ОбъектОфлайнОборудование.ВидТранспортаОфлайнОбмена = Перечисления.ВидыТранспортаОфлайнОбмена.FILE;
	КонецЕсли;
	
	Если ПодключаемоеОборудованиеОбъект.ДрайверОборудования = Справочники.ДрайверыОборудования.Драйвер1СККМOffline Тогда
		ОбъектОфлайнОборудование.ОбработчикОфлайнОборудования = Перечисления.ОбработчикиОфлайнОборудования.Обработчик1СККМОфлайн;
	ИначеЕсли ПодключаемоеОборудованиеОбъект.ДрайверОборудования = Справочники.ДрайверыОборудования.Драйвер1СККМED Тогда
		ОбъектОфлайнОборудование.ОбработчикОфлайнОборудования = Перечисления.ОбработчикиОфлайнОборудования.Обработчик1СККМED;
	КонецЕсли;
	
	ОбъектОфлайнОборудование.ТипПодключенияОборудования = Перечисления.ТипыПодключенияОборудования.ЛокальноеПодключение;
	ОбъектОфлайнОборудование.РабочееМесто = ПодключаемоеОборудованиеОбъект.РабочееМесто;
	ОбъектОфлайнОборудование.ИдентификаторWebСервисОборудования = ПодключаемоеОборудованиеОбъект.УдалитьИдентификаторWebСервисОборудования;
	
	ОбъектОфлайнОборудование.Записать();
	
	ПараметрыУстройства = Справочники.ПодключаемоеОборудование.ПараметрыУстройства(СсылкаНаПодключаемоеОборудование);
	Справочники.ОфлайнОборудование.СохранитьПараметрыУстройства(СсылкаНаОфлайнОборудование, ПараметрыУстройства);
	
	Если МенеджерОборудованияВызовСервера.ИспользуетсяОфлайнОборудование() Тогда
		МодульМенеджерОфлайнОборудованияВызовСервераПереопределяемый = ОбщегоНазначения.ОбщийМодуль("МенеджерОфлайнОборудованияВызовСервераПереопределяемый");
		МодульМенеджерОфлайнОборудованияВызовСервераПереопределяемый.ОбработатьПереходСправочникаПодключаемоеОборудованиеНаОфлайнОборудование(
		СсылкаНаПодключаемоеОборудование, ОбъектОфлайнОборудование.Ссылка);
	КонецЕсли;
	
	
КонецПроцедуры

// АПК:1328-вкл
// АПК:1327-вкл

#КонецОбласти

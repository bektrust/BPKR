
#Область ПрограммныйИнтерфейс

#Область Системные

// Возвращает номер версии библиотеки подключаемого оборудования.
//
// Возвращаемое значение:
//  Строка.
//
Функция ВерсияБиблиотеки() Экспорт
	
	Возврат МенеджерОборудования.ВерсияБиблиотеки();
	
КонецФункции

// Получает текущую дату сервера, приведенную к часовому поясу сеанса.
// Предназначена для использования вместо функции ТекущаяДатаСеанса.
//
// Возвращаемое значение:
//  Дата - текущая дата сеанса.
//
Функция ДатаСеанса() Экспорт
#Если МобильноеПриложениеСервер Тогда
	// BSLLS:DeprecatedCurrentDate-off
	Возврат ТекущаяДата(); // АПК: 143 особенность мобильного приложения	
	// BSLLS:DeprecatedCurrentDate-on
#Иначе
	Возврат ТекущаяДатаСеанса();
#КонецЕсли
КонецФункции

// Возвращает список доступных типов оборудования.
// 
// Возвращаемое значение:
//   Массив из ПеречислениеСсылка.ТипыПодключаемогоОборудования - Массив доступных типов подключаемого оборудования в конфигурации.
//
Функция ДоступныеТипыОборудования() Экспорт
	
	СписокТиповОборудования = Новый Массив;
	СтандартнаяОбработка = Истина;
	
	МенеджерОборудованияВызовСервераПереопределяемый.ДоступныеТипыОборудования(СписокТиповОборудования, СтандартнаяОбработка);
	
	Если СтандартнаяОбработка Тогда
		СписокТиповОборудования.Очистить();
		Если ИспользуетсяУстройстваВвода() Тогда
			СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.СканерШтрихкода);
			СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.СчитывательМагнитныхКарт);
		КонецЕсли;
		Если ИспользуетсяЧекопечатающиеУстройства() Тогда
			СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ККТ);
			СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ПринтерЧеков);
		КонецЕсли;
		Если ИспользуетсяДисплеиПокупателя() Тогда
			СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ДисплейПокупателя);
		КонецЕсли;
		Если ИспользуетсяТерминалыСбораДанных() Тогда
			СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ТерминалСбораДанных);
		КонецЕсли;
		Если ИспользуетсяПлатежныеСистемы() Тогда
			СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ЭквайринговыйТерминал);
		КонецЕсли;
		Если ИспользуетсяВесовоеОборудование() Тогда
			СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ЭлектронныеВесы);
			СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток);
		КонецЕсли;
		Если ИспользуетсяПринтерыЭтикеток() Тогда
			СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ПринтерЭтикеток);
		КонецЕсли;
		Если ИспользуетсяСчитывательRFID() Тогда
			СписокТиповОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.СчитывательRFID);
		КонецЕсли;
	КонецЕсли;
	
	УдалитьККМОфлайн = СписокТиповОборудования.Найти(Перечисления.ТипыПодключаемогоОборудования.УдалитьККМОфлайн);
	Если УдалитьККМОфлайн <> Неопределено Тогда
		СписокТиповОборудования.Удалить(УдалитьККМОфлайн);
	КонецЕсли;
	
	ФискальныйРегистратор = СписокТиповОборудования.Найти(Перечисления.ТипыПодключаемогоОборудования.ФискальныйРегистратор);
	Если ФискальныйРегистратор <> Неопределено Тогда
		СписокТиповОборудования.Удалить(ФискальныйРегистратор);
	КонецЕсли;
	
	Возврат СписокТиповОборудования;
	
КонецФункции

// Функция возвращает Истина, если функциональная подсистема существует в конфигурации.
//
// Параметры:
//  ПолноеИмяПодсистемы - Строка - полное имя объекта метаданных подсистема
//                        без слов "Подсистема." и с учетом регистра символов.
//                        Например: "СтандартныеПодсистемы.ВариантыОтчетов".
//  Возвращаемое значение:
//   Булево - Истина, если существует.
//
Функция ПодсистемаСуществует(ПолноеИмяПодсистемы) Экспорт
	
	Возврат ОбщегоНазначения.ПодсистемаСуществует(ПолноеИмяПодсистемы);
	
КонецФункции

// Возвращает доступность добавление новых драйверов.
// 
// Возвращаемое значение:
//  Булево.
//
Функция ДоступноДобавлениеНовыхДрайверов() Экспорт
	
	Результат = Истина;
	ДобавлениеНовыхДрайверовДоступно = Результат; 
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияВызовСервераПереопределяемый.ДоступноДобавлениеНовыхДрайверов(ДобавлениеНовыхДрайверовДоступно, СтандартнаяОбработка);
	Результат = ?(СтандартнаяОбработка, Результат, ДобавлениеНовыхДрайверовДоступно);
	Возврат Результат; 
	
КонецФункции

// Возвращает доступность сетевого оборудования.
//
// Возвращаемое значение:
//  Булево.
//
Функция ДоступноСетевоеОборудование() Экспорт
	
	Результат = Истина;  
	СетевоеОборудованиеДоступно = Результат; 
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияВызовСервераПереопределяемый.ДоступноСетевоеОборудование(СетевоеОборудованиеДоступно, СтандартнаяОбработка);
	Результат = ?(СтандартнаяОбработка, Результат, СетевоеОборудованиеДоступно);
	Возврат Результат; 
	
КонецФункции

// Возвращает признак доступности распределенной фискализации.
// 
// Возвращаемое значение:
//  Булево.
//
Функция ДоступноРаспределеннаяФискализация() Экспорт
	
	Результат = Истина;
	РаспределеннаяФискализацияДоступна = Результат; 
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияВызовСервераПереопределяемый.ДоступноРаспределеннаяФискализация(РаспределеннаяФискализацияДоступна, СтандартнаяОбработка);
	Результат = ?(СтандартнаяОбработка, Результат, РаспределеннаяФискализацияДоступна);
	Возврат Результат; 
	
КонецФункции

// Возвращает Истина, если используется устройства ввода и эти подсистемы существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяУстройстваВвода() Экспорт
	
	Возврат ОбщегоНазначения.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.УстройстваВвода");
	
КонецФункции

// Возвращает Истина, если используется устройства "Шаблоны магнитных карт" и эти подсистемы существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяШаблоныМагнитныхКарт() Экспорт
	
	Возврат ОбщегоНазначения.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.УстройстваВвода.ШаблоныМагнитныхКарт");
	
КонецФункции

// Возвращает Истина, если используется подсистемы фискальных устройств и эти подсистемы существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяЧекопечатающиеУстройства() Экспорт
	
	Возврат ОбщегоНазначения.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ЧекопечатающиеУстройства");
	
КонецФункции

// Возвращает Истина, если используется "Кассовая смена" и эти подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяКассоваяСмена() Экспорт
	
	Возврат ОбщегоНазначения.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ЧекопечатающиеУстройства.КассоваяСмена");
	
КонецФункции

// Возвращает Истина, если используется подсистема "Платежные системы" и эта подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяПлатежныеСистемы() Экспорт
	
	Возврат ОбщегоНазначения.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ПлатежныеСистемы");
	
КонецФункции

// Возвращает Истина, если используется подсистема "Дисплеи покупателя" и эта подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяДисплеиПокупателя() Экспорт
	
	Возврат ОбщегоНазначения.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ДисплеиПокупателя");
	
КонецФункции

// Возвращает Истина, если используется подсистема "Весовое оборудование" и эта подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяВесовоеОборудование() Экспорт
	
	Возврат ОбщегоНазначения.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ВесовоеОборудование");
	
КонецФункции

// Возвращает Истина, если используется подсистема "Терминалы сбора данных" и эта подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяТерминалыСбораДанных() Экспорт
	
	Возврат ОбщегоНазначения.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ТерминалыСбораДанных");
	
КонецФункции

// Возвращает Истина, если используется подсистема "Принтеры этикеток" и эта подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяПринтерыЭтикеток() Экспорт
	
	Возврат ОбщегоНазначения.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ПринтерыЭтикеток");
	
КонецФункции

// Возвращает Истина, если используется подсистема "Считыватель RFID" и эта подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяСчитывательRFID() Экспорт
	
	Возврат ОбщегоНазначения.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.СчитывательRFID");
	
КонецФункции

// Возвращает Истина, если используется подсистема "Офлайн-оборудование" и эта подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяОфлайнОборудование() Экспорт
	
	Возврат ОбщегоНазначения.ПодсистемаСуществует("ПоддержкаОборудования.ОфлайнОборудование");
	
КонецФункции

// Возвращает Истина, если используется подсистема "Печать этикеток и ценников" и эта подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяПечатьЭтикетокИЦенников() Экспорт
	
	Возврат ОбщегоНазначения.ПодсистемаСуществует("ПоддержкаОборудования.ПечатьЭтикетокИЦенников");
	
КонецФункции

// Возвращает Истина, если используется подсистема "Электронные сертификаты НСПК" и эта подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяЭлектронныеСертификатыНСПК() Экспорт
	
	Возврат ОбщегоНазначения.ПодсистемаСуществует("ПоддержкаОборудования.ЭлектронныеСертификатыНСПК");
	
КонецФункции

#КонецОбласти

#Область РабочееМесто

// Функция возвращает из переменной сеанса имя компьютера клиента.
// 
// Возвращаемое значение:
//  СправочникСсылка.РабочиеМеста.
//
Функция РабочееМестоКлиента() Экспорт

	УстановитьПривилегированныйРежим(Истина);
	Возврат ПараметрыСеанса.РабочееМестоКлиента;

КонецФункции

// Функция возвращает список рабочих мест, соответствующих указанному имени компьютера.
//
// Параметры:
//  ИдентификаторКлиента - Строка - идентификатор клиента для рабочего места
//
// Возвращаемое значение:
//  Массив из СправочникСсылка.РабочиеМеста.
//
Функция НайтиРабочиеМестаПоИдентификатору(ИдентификаторКлиента) Экспорт
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат Новый Массив();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	РабочиеМеста.Ссылка
	|ИЗ
	|	Справочник.РабочиеМеста КАК РабочиеМеста
	|ГДЕ
	|	РабочиеМеста.Код = &Код
	|	И РабочиеМеста.ПометкаУдаления = ЛОЖЬ
	|");
	
	Запрос.УстановитьПараметр("Код", ИдентификаторКлиента);
	СписокРабочиеМеста = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат СписокРабочиеМеста;
	
КонецФункции

// Функция устанавливает в переменную сеанса имя компьютера клиента.
//
// Параметры:
//  РабочееМестоКлиента - СправочникСсылка.РабочиеМеста
//
Процедура УстановитьРабочееМестоКлиента(РабочееМестоКлиента) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	ПараметрыСеанса.РабочееМестоКлиента = РабочееМестоКлиента;
	ОбновитьПовторноИспользуемыеЗначения();

КонецПроцедуры

// Функция возвращает созданное рабочее место клиента.
//
// Параметры:
//  Параметры - Структура:
//	 * ИдентификаторКлиента - УникальныйИдентификатор.
//	 * ИмяКомпьютера - Строка.
//
// Возвращаемое значение:
//  СправочникСсылка.РабочиеМеста.
//
Функция СоздатьРабочееМестоКлиента(Параметры) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	РабочееМесто = Справочники.РабочиеМеста.СоздатьЭлемент();
	РабочееМесто.Код           = Параметры.ИдентификаторКлиента;
	РабочееМесто.ИмяКомпьютера = Параметры.ИмяКомпьютера;
	МенеджерОборудованияКлиентСервер.ЗаполнитьНаименованиеРабочегоМеста(РабочееМесто, ПользователиИнформационнойБазы.ТекущийПользователь());
	РабочееМесто.Записать();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат РабочееМесто.Ссылка;

КонецФункции 

// Процедура устанавливает значения параметров сеанса, относящихся к подключаемому оборудованию.
//
// Параметры:
//  ИменаПараметровСеанса - Массив - устанавливаемые идентификаторы параметров сеанса
//
Процедура УстановкаПараметровСеанса(ИменаПараметровСеанса)  Экспорт
	
	Если ИменаПараметровСеанса <> Неопределено Тогда
		
		Для Каждого ИмяПараметра Из ИменаПараметровСеанса Цикл
			Если ИмяПараметра = "РабочееМестоКлиента" Тогда
				УстановитьПараметрыСеансаПодключаемогоОборудования(ИмяПараметра, Неопределено);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура устанавливает значения параметров сеанса, относящихся к подключаемому оборудованию.
//
// Параметры:
//  ИмяПараметра - Строка - имя параметра сеанса. 
//  УстановленныеПараметры - Массив
//
Процедура УстановитьПараметрыСеансаПодключаемогоОборудования(ИмяПараметра, УстановленныеПараметры) Экспорт

	Если ИмяПараметра = "РабочееМестоКлиента" Тогда
		
		// Если с идентификатором клиента текущего сеанса связано одно рабочее место,
		// то его сразу и запишем в параметры сеанса.
		ТекущееРМ           = Справочники.РабочиеМеста.ПустаяСсылка();
		
		СписокРМ = НайтиРабочиеМестаПоИдентификатору(МенеджерОборудованияКлиентСервер.ИдентификаторКлиентаДляРабочегоМеста());
		Если СписокРМ.Количество() = 0 Тогда
			// Будет создано с клиента.
		Иначе
			ТекущееРМ = СписокРМ[0];
		КонецЕсли;
		
		УстановитьРабочееМестоКлиента(ТекущееРМ);
		
	КонецЕсли;
	
КонецПроцедуры

// Функция возвращает типы используемого оборудования для текущего рабочего места.
// 
// Возвращаемое значение:
//  Массив.
// 
Функция ТипыИспользуемогоОборудованияТекущегоРабочегоМеста()  Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	РабочееМесто = МенеджерОборудованияВызовСервера.РабочееМестоКлиента();
	
	Если ЗначениеЗаполнено(РабочееМесто) Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПодключаемоеОборудование.ТипОборудования КАК ТипОборудования
		|ИЗ
		|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|ГДЕ
		|	ПодключаемоеОборудование.УстройствоИспользуется
		|	И ПодключаемоеОборудование.РабочееМесто = &РабочееМесто");
		
		Запрос.УстановитьПараметр("РабочееМесто", РабочееМесто);
		
		Результат = Запрос.Выполнить();
		Возврат Результат.Выгрузить().ВыгрузитьКолонку("ТипОборудования");
		
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

// АПК: 142-выкл обратная совместимость

// Функция возвращает список подключенного в справочнике ПО
//
// Параметры:
//  ТипыПО - Структура, Массив, Строка - тип оборудования для выбора устройства.
//  Идентификатор - СправочникСсылка.ПодключаемоеОборудование - подключаемое устройство.
//  РабочееМесто - СправочникСсылка.РабочиеМеста.
//  СетевоеОборудование - Булево - использовать сетевое оборудование при подключении.
//  СерверноеОборудование - Булево.
//  ТолькоАвтоматическаяФискализация - Булево.
//
// Возвращаемое значение:
//  Массив из СправочникСсылка.ПодключаемоеОборудование.
// 
Функция ОборудованиеПоПараметрам(ТипыПО = Неопределено, Идентификатор = Неопределено, РабочееМесто = Неопределено, 
	СетевоеОборудование = Истина, СерверноеОборудование = Ложь, ТолькоАвтоматическаяФискализация = Ложь) Экспорт
	
	Возврат Справочники.ПодключаемоеОборудование.ОборудованиеПоПараметрам(ТипыПО, Идентификатор, РабочееМесто, 
		СетевоеОборудование, СерверноеОборудование, ТолькоАвтоматическаяФискализация);
	
КонецФункции

// АПК: 142-вкл

// Функция возвращает структуру с данными устройства.
//
// Параметры:
//  Идентификатор - СправочникСсылка.ПодключаемоеОборудование.
//
// Возвращаемое значение:
//  Структура.
//
Функция ДанныеУстройства(Идентификатор) Экспорт
	
	Возврат Справочники.ПодключаемоеОборудование.ДанныеУстройства(Идентификатор);
	
КонецФункции

// Функция возвращает по идентификатору устройства его параметры
//
// Параметры:
//  Идентификатор - СправочникСсылка.ПодключаемоеОборудование.
//
// Возвращаемое значение:
//  Структура.
//
Функция ПараметрыУстройства(Идентификатор) Экспорт
	
	Возврат Справочники.ПодключаемоеОборудование.ПараметрыУстройства(Идентификатор);
	
КонецФункции

// Процедура предназначена для сохранения параметров устройства
// в реквизит Параметры типа хранилище значения в элементе справочника.
//
// Параметры:
//  Идентификатор - СправочникСсылка.ПодключаемоеОборудование.
//  Параметры - Структура - параметры устройства.
//
// Возвращаемое значение:
//  Булево.
//
Функция СохранитьПараметрыУстройства(Идентификатор, Параметры) Экспорт
	
	Возврат Справочники.ПодключаемоеОборудование.СохранитьПараметрыУстройства(Идентификатор, Параметры);
	
КонецФункции

// Функция возвращает структуру с данными драйвера.
//
// Параметры:
//  Идентификатор - СправочникСсылка.ПодключаемоеОборудование.
//
// Возвращаемое значение:
//  Структура.
//
Функция ДанныеДрайвераОборудования(Идентификатор) Экспорт
	
	Возврат Справочники.ДрайверыОборудования.ДанныеДрайвераОборудования(Идентификатор);
	
КонецФункции

// Получить описание драйвера XML пакета.
//
// Параметры:
//  Данные - Строка.
//
// Возвращаемое значение:
//  Структура.
//
Функция ПолучитьОписаниеДрайвера(Данные) Экспорт
	
	Параметры = Новый Структура();
	
	Если Не ПустаяСтрока(Данные) Тогда
		ЧтениеXML = Новый ЧтениеXML; 
		ЧтениеXML.УстановитьСтроку(Данные);
		ЧтениеXML.ПерейтиКСодержимому();
		Если ЧтениеXML.Имя = "DriverDescription" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			НаименованиеДрайвера      = ЧтениеXML.ЗначениеАтрибута("Name");
			ОписаниеДрайвера          = ЧтениеXML.ЗначениеАтрибута("Description");
			ТипОборудования           = ЧтениеXML.ЗначениеАтрибута("EquipmentType");
			ВерсияДрайвера            = ЧтениеXML.ЗначениеАтрибута("DriverVersion");
			ВерсияИнтеграционногоКомпонента = ЧтениеXML.ЗначениеАтрибута("IntegrationComponentVersion");
			ИнтеграционныйКомпонент   = ВРег(ЧтениеXML.ЗначениеАтрибута("IntegrationComponent")) = "TRUE";
			ОсновнойДрайверУстановлен = ВРег(ЧтениеXML.ЗначениеАтрибута("MainDriverInstalled")) = "TRUE";
			URLЗагрузкиДрайвера       = ЧтениеXML.ЗначениеАтрибута("DownloadURL");
			ЛогДрайвераВключен        = ВРег(ЧтениеXML.ЗначениеАтрибута("LogIsEnabled")) = "TRUE";
			ЛогДрайвераПутьКФайлу     = ЧтениеXML.ЗначениеАтрибута("LogPath");
			Параметры.Вставить("НаименованиеДрайвера", НаименованиеДрайвера);
			Параметры.Вставить("ОписаниеДрайвера", ОписаниеДрайвера);
			Параметры.Вставить("ТипОборудования", ТипОборудования);
			Параметры.Вставить("ВерсияДрайвера", ВерсияДрайвера);
			Параметры.Вставить("ВерсияИнтеграционногоКомпонента", ВерсияИнтеграционногоКомпонента);
			Параметры.Вставить("ИнтеграционныйКомпонент", ИнтеграционныйКомпонент);
			Параметры.Вставить("ОсновнойДрайверУстановлен", ОсновнойДрайверУстановлен);
			Параметры.Вставить("URLЗагрузкиДрайвера", URLЗагрузкиДрайвера);
			Параметры.Вставить("ЛогДрайвераВключен", ЛогДрайвераВключен);
			Параметры.Вставить("ЛогДрайвераПутьКФайлу", ЛогДрайвераПутьКФайлу);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Параметры;
	
КонецФункции

// Функция возвращает драйвера по типу оборудования
//
// Параметры:
//  ТипОборудования - ПеречислениеСсылка.ТипыПодключаемогоОборудования - типы подключаемого оборудования.
//  ТолькоДоступные - Булево - признак только доступных драйверов.
//  СнятыеСПоддержкиДрайвера - Булево - признак отображения снятых с поддержки драйверов.
//
// Возвращаемое значение:
//  СписокЗначений.
//
Функция ДрайвераПоТипуОборудования(ТипОборудования, ТолькоДоступные = Истина, СнятыеСПоддержкиДрайвера = Ложь) Экспорт
	
	Возврат Справочники.ДрайверыОборудования.ДрайвераПоТипуОборудования(ТипОборудования, ТолькоДоступные, СнятыеСПоддержкиДрайвера);
	
КонецФункции

// Функция создает запись в справочнике о новом драйвере.
//
// Параметры:
//  ПараметрыСоздания - Структура - параметры создания оборудования.
//
// Возвращаемое значение:
//  СправочникСсылка.ПодключаемоеОборудование.
//
Функция СоздатьДрайверОборудования(ПараметрыСоздания) Экспорт
	
	Возврат Справочники.ДрайверыОборудования.СоздатьНовыйЭлемент(ПараметрыСоздания);
	
КонецФункции

// Функция читает корневой элемент XML.
//
// Параметры:
//  СтрокаXML - Строка - XML строка.
//
// Возвращаемое значение:
//  Структура:
//   * ЭлементXML - Строка.
//
Функция ПрочитатьКорневойЭлементXML(СтрокаXML) Экспорт
	
	Результат = Новый Структура();
	Если Не ПустаяСтрока(СтрокаXML) Тогда
		ЧтениеXML = Новый ЧтениеXML; 
		ЧтениеXML.УстановитьСтроку(СтрокаXML);
		ЧтениеXML.ПерейтиКСодержимому();
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			Если ЧтениеXML.КоличествоАтрибутов() > 0 Тогда
				Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
					Результат.Вставить(ЧтениеXML.Имя, ЧтениеXML.Значение);
				КонецЦикла
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#Область ПереустановкаДрайвера

// Устанавливает признак необходимости переустановки оборудования для подключаемого оборудования на рабочем месте.
//
// Параметры:
//  РабочееМесто - СправочникСсылка.РабочиеМеста.
//  ДрайверОборудования - СправочникСсылка.ДрайверыОборудования. 
//  Признак - Булево - требуется переустановить драйвер
//
Процедура УстановитьПризнакПереустановкиДрайвера(РабочееМесто, ДрайверОборудования, Признак) Экспорт
	
	МенеджерОборудования.УстановитьПризнакПереустановкиДрайвера(РабочееМесто, ДрайверОборудования, Признак);
	
КонецПроцедуры

#КонецОбласти

#Область RFID

// Получить таблицу меток RFID.
//
// Параметры:
//  ДанныеМеток - Строка
//
// Возвращаемое значение:
//  Массив
// 
Функция МеткиRFID(ДанныеМеток) Экспорт
	
	Результат = Новый Массив();
	
	ЧтениеXML = Новый ЧтениеXML; 
	ЧтениеXML.УстановитьСтроку(ДанныеМеток);
	ЧтениеXML.ПерейтиКСодержимому();
	
	Если ЧтениеXML.Имя = "Table" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
		Пока ЧтениеXML.Прочитать() Цикл  
			Если ЧтениеXML.Имя = "Tag" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
				
				// АПК: 1353-выкл TID, EPC, USER - аббревиатура
				// Получение банков памяти считанной метки.
				TID = ЧтениеXML.ЗначениеАтрибута("TID");
				EPC = ЧтениеXML.ЗначениеАтрибута("EPC");
				USER = ЧтениеXML.ЗначениеАтрибута("USER");
				// Декодирование банка EPC по формату SGTIN.  
				ПозицияДанных = МенеджерОборудованияКлиентСервер.ДекодированиеДанныхSGTIN(EPC);
				ПозицияДанных.Вставить("TID" , TID);  // Добавляем в структура значения TID чипа метки.
				ПозицияДанных.Вставить("USER", USER); // Добавляем в структура значения банка USER.
				ПозицияДанных.Вставить("UserMemory", МенеджерОборудованияКлиентСервер.ПреобразоватьHEXВСтроку(USER));
				// АПК: 1353-вкл
				
				Результат.Добавить(ПозицияДанных);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область РаспределеннаяФискализации

// Создает обсуждение фискализации.
// 
// Возвращаемое значение:
//  Неопределено, ИдентификаторОбсужденияСистемыВзаимодействия - Обсуждение фискализации
//
Функция ОбсуждениеФискализации() Экспорт
	
	Обсуждение = Неопределено;
	
	Если НЕ ДоступноРаспределеннаяФискализация() Тогда
		Возврат Обсуждение;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат Обсуждение;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИдентификаторОбсужденияСтрока = Константы.ИдентификаторОбсужденияФискализации.Получить();
	Попытка
		Если ЗначениеЗаполнено(ИдентификаторОбсужденияСтрока) Тогда
			ИдентификаторОбсуждения = Новый ИдентификаторОбсужденияСистемыВзаимодействия(ИдентификаторОбсужденияСтрока);
			Обсуждение = СистемаВзаимодействия.ПолучитьОбсуждение(ИдентификаторОбсуждения);
		КонецЕсли;
		
		Если Обсуждение = Неопределено Тогда
			Обсуждение = СистемаВзаимодействия.СоздатьОбсуждение();
			Обсуждение.Отображаемое = Ложь;
			Обсуждение.Заголовок = НСтр("ru='Фискализация чеков'");
			Обсуждение.Ключ = Строка(Новый УникальныйИдентификатор);
			Обсуждение.Записать();
			Константы.ИдентификаторОбсужденияФискализации.Установить(Строка(Обсуждение.Идентификатор));
		КонецЕсли;
	
		// Добавить текущего пользователя в обсуждение.
		Если НЕ Обсуждение.Участники.Содержит(СистемаВзаимодействия.ИдентификаторТекущегоПользователя()) Тогда
			Обсуждение.Участники.Добавить(СистемаВзаимодействия.ИдентификаторТекущегоПользователя());
			Обсуждение.Записать();
		КонецЕсли;
		
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
	Возврат Обсуждение.Идентификатор;
	
КонецФункции

// Создает сообщение для фискализации чека
// 
// Параметры:
//  ИдентификаторЧека - УникальныйИдентификатор
//  ОрганизацияИИН - Строка
//
Процедура СоздатьСообщениеФискализации(ИдентификаторЧека, ОрганизацияИИН = Неопределено) Экспорт
	
	Если НЕ ДоступноРаспределеннаяФискализация() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	Если СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована() Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		ИдентификаторОбсужденияСтрока = Константы.ИдентификаторОбсужденияФискализации.Получить();
		Если ЗначениеЗаполнено(ИдентификаторОбсужденияСтрока) Тогда
			Попытка
				ИдентификаторОбсуждения = Новый ИдентификаторОбсужденияСистемыВзаимодействия(ИдентификаторОбсужденияСтрока);
				СистемаВзаимодействия.ПолучитьОбсуждение(ИдентификаторОбсуждения);
				НовоеСообщение = СистемаВзаимодействия.СоздатьСообщение(ИдентификаторОбсуждения);
				НовоеСообщение.Дата = ДатаСеанса();
				ТекстСообщения = НСтр("ru='Фискализация чека'") + Символы.НПП + ИдентификаторЧека;
				Если Не ПустаяСтрока(ОрганизацияИИН) Тогда
					ТекстСообщения = ТекстСообщения + Символы.НПП + ОрганизацияИИН;
				КонецЕсли;
				НовоеСообщение.Текст = ТекстСообщения;
				НовоеСообщение.Записать();
			Исключение
			#Если НЕ МобильноеПриложениеСервер Тогда
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка системы взаимодействия'", 
					ОбщегоНазначения.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,,, 
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			#КонецЕсли
			КонецПопытки;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ИнтерфейсныйПроцедурыИФункции

// Установить свойства элемента управления
//
// Параметры:
//  ЭлементУправления - ЭлементУправления
//
Процедура ПодготовитьЭлементУправления(ЭлементУправления) Экспорт
	
#Если МобильноеПриложениеСервер Тогда
	СтандартнаяОбработка = Истина;
	Если СтандартнаяОбработка Тогда
		ЭлементУправления.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		ЭлементУправления.ШрифтЗаголовка = ШрифтыСтиля.МелкийШрифтТекста;
	КонецЕсли;
#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

// Base64 в штрихкод.
// 
// Параметры:
//  ШтрихкодВBase64 - Строка - Штрихкод в base64
// 
// Возвращаемое значение:
//  Строка - Base64 в штрихкод
//
Функция Base64ВШтрихкод(ШтрихкодВBase64) Экспорт
	
	ДвоичныеДанные = Base64Значение(ШтрихкодВBase64);
	Если ДвоичныеДанные = Неопределено Тогда
		Штрихкод = ШтрихкодВBase64;
	Иначе
		Штрихкод = ПолучитьСтрокуИзДвоичныхДанных(ДвоичныеДанные);
	КонецЕсли;
	
	Возврат Штрихкод;
	
КонецФункции

// Штрихкод в base64.
// 
// Параметры:
//  Штрихкод - Строка - Штрихкод
// 
// Возвращаемое значение:
//  Строка - Штрихкод в base64
//
Функция ШтрихкодВBase64(Штрихкод) Экспорт
	
	Если Штрихкод = Неопределено Тогда 
		ДвоичныеДанныеСтроки = Неопределено;
	Иначе
		ДвоичныеДанныеСтроки = ПолучитьДвоичныеДанныеИзСтроки(Штрихкод);
		ШтрихкодBase64 = Base64Строка(ДвоичныеДанныеСтроки);
		ШтрихкодBase64 = СтрЗаменить(ШтрихкодBase64, Символы.ПС, "");
		ШтрихкодBase64 = СтрЗаменить(ШтрихкодBase64, Символы.ВК, "");
	КонецЕсли;
	
	Возврат ШтрихкодBase64;
	
КонецФункции

#Область ЕМРЦ

// Получает цену ЕМРЦ из данных информационной базы на дату.
//
// Параметры:
//  ОсобенностьУчета - Перечисления.ВидыМаркированнойПродукцииБПО - тип маркированной продукции для проверки цены.
//  Период - Дата - дата проверки цены.
//  ЕМРЦ - Число - значение ЕМРЦ.
//
Процедура ПолучитьЦенуЕМРЦ(ОсобенностьУчета, Период = Неопределено, ЕМРЦ = 0) Экспорт
	РегистрыСведений.ЗначенияЕМРЦ.ПолучитьЦенуЕМРЦ(Перечисления.ВидыМаркированнойПродукцииБПО.Табак, Период, ЕМРЦ);
КонецПроцедуры

#КонецОбласти

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать ГенерацияШтрихкода.ИзображениеШтрихкода()
// Формирование изображения штрихкода.
//
// Параметры: 
//   ПараметрыШтрихкода - Структура - см.ГенерацияШтрихкода.ПараметрыГенерацииШтрихкода()
//
// Возвращаемое значение: 
//   Картинка - Картинка со сформированным штрихкодом или НЕОПРЕДЕЛЕНО.
//
Функция ПолучитьКартинкуШтрихкода(ПараметрыШтрихкода) Экспорт
	
	РезультатОперации = ГенерацияШтрихкода.ИзображениеШтрихкода(ПараметрыШтрихкода);
	Если  РезультатОперации.ДвоичныеДанные <> Неопределено Тогда
		Возврат РезультатОперации.Картинка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Устарела. Следует использовать РабочееМестоКлиента()
// Функция возвращает из переменной сеанса имя компьютера клиента.
//
// Возвращаемое значение: 
//   СправочникСсылка.РабочиеМеста - рабочее место клиента.
//
Функция ПолучитьРабочееМестоКлиента() Экспорт
	
	Возврат РабочееМестоКлиента();
	
КонецФункции

// Функция определяет тип штрихкода по значение кода.
//
// Параметры: 
//   Штрихкод - Строка - штрихкод для определения типа.
//
// Возвращаемое значение: 
//   Строка - тип штрихкода строкой.
//
Функция ОпределитьТипШтрихкода(Штрихкод) Экспорт
	
	Возврат МенеджерОборудованияКлиентСервер.ОпределитьТипШтрихкода(Штрихкод);
	
КонецФункции

#Область СовместимостьГОСИС
 
// Функция возвращает поддерживает ли фискальное устройство.
// 
// Параметры:
//  ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - Идентификатор устройства.
// 
// Возвращаемое значение:
//  Булево - Фискальное устройство поддерживает проверку кодов маркировки
Функция ФискальноеУстройствоПоддерживаетПроверкуКодовМаркировки(ИдентификаторУстройства) Экспорт
	
	Если ИспользуетсяЧекопечатающиеУстройства() Тогда
		МодульОборудованиеЧекопечатающиеУстройстваВызовСервера = ОбщегоНазначения.ОбщийМодуль("ОборудованиеЧекопечатающиеУстройстваВызовСервера");
		Возврат МодульОборудованиеЧекопечатающиеУстройстваВызовСервера.ФискальноеУстройствоПоддерживаетПроверкуКодовМаркировки(ИдентификаторУстройства);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Функция возвращает для фискального устройства версию ФФД.
// 
// Параметры:
//  ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - Идентификатор устройства.
// 
// Возвращаемое значение:
//  Неопределено - Фискальное устройство поддерживает версию ФФД
Функция ФискальноеУстройствоПоддерживаетВерсиюФФД(ИдентификаторУстройства) Экспорт
	
	Если ИспользуетсяЧекопечатающиеУстройства() Тогда
		МодульОборудованиеЧекопечатающиеУстройстваВызовСервера = ОбщегоНазначения.ОбщийМодуль("ОборудованиеЧекопечатающиеУстройстваВызовСервера");
		Возврат МодульОборудованиеЧекопечатающиеУстройстваВызовСервера.ФискальноеУстройствоПоддерживаетВерсиюФФД(ИдентификаторУстройства);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти




#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Заполняет параметры работы клиента на сервере
// Стандарт Минимизация количества серверных вызовов и трафика.
//
// Параметры:
//   Параметры - Структура
//    * ИдентификаторКлиента - Строка - (входящий) идентификатор рабочего места клиента
//    * ИменаМакетовДляПереустановки - Массив из строк - имена макетов для переустановки внешних компонент
//    * ИдентификаторОбсужденияРаспределеннойФискализации - ИдентификаторОбсужденияСистемыВзаимодействия -
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	Параметры.ИменаМакетовДляПереустановки = ПереустановитьПомеченныеПоставляемыеДрайверы(Параметры.ИдентификаторКлиента);
	Параметры.ИдентификаторОбсужденияРаспределеннойФискализации = ПодключениеСистемыВзаимодействия();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает массив содержащий имена макетов для переустановки драйверов, для которых требуется переустановка,
// а так же снимает флаг признака переустановки у найденных элементов.
//
// Параметры:
//   ИдентификаторКлиента - Строка - идентификатор клиента для рабочего места
//
// Возвращаемое значение:
//   Массив из строк - имена макетов внешних компонент, которые требуется переустановить
Функция ПереустановитьПомеченныеПоставляемыеДрайверы(ИдентификаторКлиента)
	
	МассивРабочихМест = НайтиРабочиеМестаПоИдентификатору(ИдентификаторКлиента);
	МассивИменаМакетов = Новый Массив();
	
	Если МассивРабочихМест.Количество() = 0 Тогда
		РабочееМесто = Неопределено;
	Иначе
		РабочееМесто = МассивРабочихМест[0];
	КонецЕсли;
	
	// Переустановить драйверы помеченные флагом для переустановки.
	Если ЗначениеЗаполнено(РабочееМесто) Тогда
		СписокОборудования = ОборудованиеПоПараметрам(Неопределено, Неопределено, РабочееМесто);
		Для Каждого Оборудование Из СписокОборудования Цикл
			Если Оборудование.ПодключениеИзМакета И Оборудование.МакетДоступен И Оборудование.ТребуетсяПереустановка Тогда
				МассивИменаМакетов.Добавить(Оборудование.ИмяМакетаДрайвера);
			КонецЕсли;
			МенеджерОборудованияВызовСервера.УстановитьПризнакПереустановкиДрайвера(
				РабочееМесто,
				Оборудование.ДрайверОборудования,
				Ложь); 
		КонецЦикла;
	КонецЕсли;
	
	Возврат МассивИменаМакетов;
	
КонецФункции

#Область РаспределеннаяФискализации

// Возвращает созданное обсуждение фискализации
//
// Возвращаемое значение:
//  Неопределено, ИдентификаторОбсужденияСистемыВзаимодействия - Обсуждение фискализации
Функция ПодключениеСистемыВзаимодействия()
	
	Если СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована() Тогда
		Возврат ОбсуждениеФискализации();
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти

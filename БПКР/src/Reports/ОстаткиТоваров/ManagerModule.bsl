#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Для подсистемы "Варианты отчетов" при работе в модели сервиса.
//
// Возвращаемое значение:
//  Массив - массив структур (варианты отчета).
Функция ВариантыНастроек() Экспорт
	Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Новый Структура("Имя, Представление", "ОстаткиПоСкладу", НСтр("ru = 'Остатки товаров'")));
КонецФункции

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;

	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ОстаткиПоСкладу");
	НастройкиВарианта.Описание = НСтр("ru = 'Остатки товаров'");
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Параметры = Новый Структура();
	Параметры.Вставить("ИспользоватьПередКомпоновкойМакета" , Истина);
	Параметры.Вставить("ИспользоватьПослеКомпоновкиМакета" , Ложь);
	Параметры.Вставить("ИспользоватьПослеВыводаРезультата" , Истина);
	Параметры.Вставить("ИспользоватьДанныеРасшифровки" , Истина);
	Параметры.Вставить("ИспользоватьПривилегированныйРежим", Истина);
	
	Возврат Параметры;
	
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Остатки товаров на %1'"), Формат(ПараметрыОтчета.КонецПериода, "ДЛФ=DD"));
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек.Настройки.Выбор, "Количество");
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек.Настройки.Выбор, "Сумма");
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", Новый Граница(КонецДня(ПараметрыОтчета.КонецПериода), ВидГраницы.Включая));
	КонецЕсли;
	
	СтруктураСчетов = СтруктураСчетов(БухгалтерскийУчетСервер.СчетаУчетаТоваров());
	
	Для Каждого Счета Из СтруктураСчетов Цикл
		
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, Счета.Ключ, Счета.Значение);
		
	КонецЦикла;
	
	// Группировка
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	Группировка = КомпоновщикНастроек.Настройки.Структура;
	Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
		Если ПолеВыбраннойГруппировки.Использование Тогда
			Если ТипЗнч(Группировка) = Тип("КоллекцияЭлементовСтруктурыНастроекКомпоновкиДанных") Тогда
				Группировка = Группировка.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			Иначе
				Группировка = Группировка.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			КонецЕсли;
			БухгалтерскиеОтчетыВызовСервера.ЗаполнитьГруппировку(ПолеВыбраннойГруппировки, Группировка);
		КонецЕсли;
	КонецЦикла;
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	// Вывод подписей
	БухгалтерскиеОтчеты.ВыводПодписейОтчета(ПараметрыОтчета, Результат);
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета, ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
КонецПроцедуры

// Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;
	
КонецПроцедуры

// Возвращает набор параметров, которые необходимо сохранять в рассылке отчетов.
// Значения параметров используются при формировании отчета в рассылке.
//
// Возвращаемое значение:
//   Структура - структура настроек, сохраняемых в рассылке с неинициализированными значениями.
//
Функция НастройкиОтчетаСохраняемыеВРассылке() Экспорт
	
	КоллекцияНастроек = Новый Структура;
	КоллекцияНастроек.Вставить("Организация"                      , Справочники.Организации.ПустаяСсылка());
	КоллекцияНастроек.Вставить("РазмещениеДополнительныхПолей"    , 0);
	КоллекцияНастроек.Вставить("Группировка"                      , Неопределено);
	КоллекцияНастроек.Вставить("ДополнительныеПоля"               , Неопределено);
	КоллекцияНастроек.Вставить("ВыводитьЗаголовок"                , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьПодвал"                   , Ложь);
	КоллекцияНастроек.Вставить("МакетОформления"                  , Неопределено);
	КоллекцияНастроек.Вставить("НастройкиКомпоновкиДанных"        , Неопределено);
	
	Возврат КоллекцияНастроек;
	
КонецФункции

// Возвращает структуру параметров, наличие которых требуется для успешного формирования отчета.
//
// Возвращаемое значение:
//   Структура - структура параметров для формирования отчета.
//
Функция ПустыеПараметрыКомпоновкиОтчета() Экспорт
	
	// Часть параметров компоновки отчета используется так же и в рассылке отчета.
	ПараметрыОтчета = НастройкиОтчетаСохраняемыеВРассылке();
	
	// Дополним параметрами, влияющими на формирование отчета.
	ПараметрыОтчета.Вставить("ПериодОтчета"         , Неопределено);
	ПараметрыОтчета.Вставить("НачалоПериода"        , Дата(1,1,1));
	ПараметрыОтчета.Вставить("КонецПериода"         , Дата(1,1,1));
	ПараметрыОтчета.Вставить("РежимРасшифровки"     , Ложь);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"    , Неопределено);
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных", Неопределено);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"  , "");
	
	Возврат ПараметрыОтчета;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтруктураСчетов(СчетаУчетаТоваров)

	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ХозрасчетныйВидыСубконто.Ссылка КАК Счет,
	               |	ХозрасчетныйВидыСубконто.ВидСубконто,
	               |	ХозрасчетныйВидыСубконто.Суммовой
	               |ПОМЕСТИТЬ ВидыСубконто
	               |ИЗ
	               |	ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто
	               |ГДЕ
	               |	ХозрасчетныйВидыСубконто.Ссылка В(&СчетаУчетаТоваров)
	               |	И ХозрасчетныйВидыСубконто.ВидСубконто = &ВидСубконтоСклады
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	Счет
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВидыСубконто.Счет КАК Счет
	               |ИЗ
	               |	ВидыСубконто КАК ВидыСубконто
	               |ГДЕ
	               |	ВидыСубконто.Суммовой = ИСТИНА
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВидыСубконто.Счет
	               |ИЗ
	               |	ВидыСубконто КАК ВидыСубконто
	               |ГДЕ
	               |	ВидыСубконто.Суммовой = ЛОЖЬ
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Хозрасчетный.Ссылка КАК Счет
	               |ИЗ
	               |	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	               |ГДЕ
	               |	НЕ Хозрасчетный.Ссылка В
	               |				(ВЫБРАТЬ
	               |					ВидыСубконто.Счет КАК Счет
	               |				ИЗ
	               |					ВидыСубконто КАК ВидыСубконто)
	               |	И Хозрасчетный.Ссылка В(&СчетаУчетаТоваров)";
				   
	Запрос.УстановитьПараметр("СчетаУчетаТоваров", СчетаУчетаТоваров);
	Запрос.УстановитьПараметр("ВидСубконтоСклады", ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
	
	Результат = Запрос.ВыполнитьПакет();
	
	СтруктураСчетов = Новый Структура;
	
	СтруктураСчетов.Вставить("СчетаУчетаСкладИНоменклатура", Результат[1].Выгрузить().ВыгрузитьКолонку("Счет"));
	
	СтруктураСчетов.Вставить("СчетаУчетаСкладТолькоКоличествоИНоменклатура", Результат[2].Выгрузить().ВыгрузитьКолонку("Счет"));
	
	СтруктураСчетов.Вставить("СчетаУчетаНоменклатураБезСклада", Результат[3].Выгрузить().ВыгрузитьКолонку("Счет"));
	
	Возврат СтруктураСчетов;
	
КонецФункции

#КонецОбласти

#КонецЕсли

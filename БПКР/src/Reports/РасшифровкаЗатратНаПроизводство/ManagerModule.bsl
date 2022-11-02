#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Ложь);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	
	Возврат Результат;

КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат "Расшифровка затрат на производство" + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();

	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек.Настройки.Выбор, "СуммаЗатрат");
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек.Настройки.Выбор, "Количество");

	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
	// Группировка
	//БухгалтерскиеОтчетыВызовСервера.ДобавитьГруппировки(ПараметрыОтчета, КомпоновщикНастроек);
	
	Если ТипЗнч(КомпоновщикНастроек) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		СтруктураНастроек = КомпоновщикНастроек.Настройки.Структура;
	Иначе
		СтруктураНастроек = КомпоновщикНастроек;
	КонецЕсли;
	
	Для Каждого ЭлементСтруктуры Из СтруктураНастроек Цикл
		Группировка = ЭлементСтруктуры;
		Если Группировка.Имя = "Группировка" Тогда // Заполнить все поля группировки.
			
			Если ТипЗнч(Группировка) = Тип("ГруппировкаКомпоновкиДанных") Тогда
				Родитель = Группировка.Родитель;
				ПерваяГруппировка = Истина;
				Индекс = Родитель.Структура.Индекс(Группировка);
				Родитель.Структура.Удалить(Группировка);
				Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
					Если ПолеВыбраннойГруппировки.Использование Тогда
						Если ПерваяГруппировка Тогда
							Группировка = Родитель.Структура.Вставить(Индекс, Тип("ГруппировкаКомпоновкиДанных"));
							ПерваяГруппировка = Ложь;
						Иначе
							Группировка = Группировка.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
						КонецЕсли;
						
						ПолеГруппировки = Группировка.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
						ПолеГруппировки.Использование  = Истина;
						ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
						Если ПолеВыбраннойГруппировки.ТипГруппировки = 1 Тогда
							ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
						ИначеЕсли ПолеВыбраннойГруппировки.ТипГруппировки = 2 Тогда
							ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
						Иначе
							ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
						КонецЕсли;
						Группировка.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
						Группировка.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
					КонецЕсли;
				КонецЦикла;
						
				// Вывод детальных записей
				ДетальныеЗаписи = Группировка.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
				ДетальныеЗаписи.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
				ДетальныеЗаписи.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
				
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ДетальныеЗаписи.Выбор, "Субконто1");
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ДетальныеЗаписи.Выбор, "Субконто2");
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ДетальныеЗаписи.Выбор, "Субконто3");
				
			КонецЕсли;
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

// Настройки размещения в панели отчетов.
//
// Параметры:
//   Настройки - Коллекция - Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации()
//   НастройкиОтчета - СтрокаДереваЗначений - Настройки размещения всех вариантов отчета.
//       см. "Реквизиты для изменения" функции ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//
// Описание:
//   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Вспомогательные методы:
//   НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//   ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь); // Отчет
//   поддерживает только этот режим.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;

	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "РасшифровкаЗатратНаПроизводство");
	НастройкиВарианта.Описание = НСтр("ru = 'Расшифровка затрат на производство.'");
КонецПроцедуры

// Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		 Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;
	
КонецПроцедуры

Функция ВариантыНастроек() Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("Имя, Представление","РасшифровкаЗатратНаПроизводство", "Расшифровка затрат на производство"));
	Возврат Массив;
	
КонецФункции

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

#КонецЕсли

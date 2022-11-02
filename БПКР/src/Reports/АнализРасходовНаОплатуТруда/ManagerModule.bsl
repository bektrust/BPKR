#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета",          Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",           Ложь);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",           Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",               Истина);
	Результат.Вставить("ИспользоватьРасширенныеПараметрыРасшифровки", Истина);
							
	Возврат Результат;
							
КонецФункции
	
Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат "Анализ расходов на оплату труда" + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", Дата(1, 1, 1));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", Дата(3999, 11, 1));
	КонецЕсли;
	
	МассивСчетов = Новый Массив;
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.НачисленнаяЗаработнаяПлата);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "МассивСчетов", МассивСчетов);
		
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);	
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	// Вывод подписей
	БухгалтерскиеОтчеты.ВыводПодписейОтчета(ПараметрыОтчета, Результат);
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета, ПараметрыОтчета.ИдентификаторОтчета, Результат);

	Если Результат.Области.Найти("Заголовок") = Неопределено Тогда
		Результат.ФиксацияСверху = 2;
	Иначе
		Результат.ФиксацияСверху = Результат.Области.Заголовок.Низ + 2;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыРасшифровкиОтчета(Адрес, Расшифровка, ПараметрыРасшифровки) Экспорт
		
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ПользовательскиеОтборы = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	ПользовательскиеОтборы.ИдентификаторПользовательскойНастройки = "Отбор";
	
	ДополнительныеСвойства = ПользовательскиеНастройки.ДополнительныеСвойства;
		
	ДанныеОбъекта = ПолучитьИзВременногоХранилища(Адрес);
	
	ОтчетОбъект       = ДанныеОбъекта.Объект;
	ДанныеРасшифровки = ДанныеОбъекта.ДанныеРасшифровки;
	
	ДополнительныеСвойства.Вставить("РежимРасшифровки", Истина);
	ДополнительныеСвойства.Вставить("Организация"     , ОтчетОбъект.Организация);

	Период        = Неопределено;
		
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.ЗагрузитьНастройки(ДанныеРасшифровки.Настройки);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ДанныеОбъекта.Объект.СхемаКомпоновкиДанных));
	
	МассивПолей = БухгалтерскиеОтчетыВызовСервера.ПолучитьМассивПолейРасшифровки(Расшифровка, ДанныеРасшифровки, КомпоновщикНастроек, Истина);

 	Для Каждого Отбор Из МассивПолей Цикл
		Если ТипЗнч(Отбор) = Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных") Тогда
			Если Отбор.Значение = NULL Тогда
				Продолжить;
			КонецЕсли;
			
			Если Отбор.Поле = "Организация" Тогда
				ДополнительныеСвойства.Вставить("Организация", Отбор.Значение);
			ИначеЕсли Отбор.Поле = "Период" Тогда
				Период = Отбор.Значение;
			Иначе
				Если Отбор.Поле <> "СчетДт" И Отбор.Поле <> "СчетКт" 
					И Отбор.Поле <> "КорСубконто1" И Отбор.Поле <> "КорСубконто2" И Отбор.Поле <> "КорСубконто3" Тогда
					Продолжить;
				Иначе
					Если Найти(Отбор.Поле,"КорСубконто") <> 0 Тогда
						Отбор.Поле = СтрЗаменить(Отбор.Поле,"КорСубконто","СубконтоДт");
					ИначеЕсли Найти(Отбор.Поле,"Счет") <> 0 Тогда
						Если Отбор.Значение.ЗапретитьИспользоватьВПроводках Тогда
							Отбор.Иерархия = Истина;
						КонецЕсли;						
					КонецЕсли;
					
					Если Отбор.Иерархия Тогда
						БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.Поле, Отбор.Значение, ВидСравненияКомпоновкиДанных.ВИерархии);
					Иначе
						БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.Поле, Отбор.Значение);
					КонецЕсли;
					
				КонецЕсли;
			КонецЕсли;	
		ИначеЕсли ТипЗнч(Отбор) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Если Отбор.Представление = "###ОтборПоОрганизации###" Тогда
				ДополнительныеСвойства.Вставить("Организация", Отбор.ПравоеЗначение);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	ДополнительныеСвойства.Вставить("НачалоПериода", ОтчетОбъект.НачалоПериода);
	ДополнительныеСвойства.Вставить("КонецПериода" , ОтчетОбъект.КонецПериода);
		
	ДополнительныеСвойства.Вставить("ПоказательБУ"     , Истина);
		
	СписокПунктовМеню = Новый СписокЗначений;
	СписокПунктовМеню.Добавить("ОтчетПоПроводкам", "Отчет по проводкам");
	
	НастройкиРасшифровки = Новый Структура;
	НастройкиРасшифровки.Вставить("ОтчетПоПроводкам", ПользовательскиеНастройки);
		
	ДанныеОбъекта.Вставить("НастройкиРасшифровки", НастройкиРасшифровки);
	Адрес = ПоместитьВоВременноеХранилище(ДанныеОбъекта, Адрес);
	ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
	ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Ложь);
	
КонецПроцедуры

#Область СлужебныйПрограммныйИнтерфейс

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

	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "АнализРасходовНаОплатуТруда");
	НастройкиВарианта.Описание = НСтр("ru = 'Анализ расходов на оплату труда.'");
КонецПроцедуры

#КонецОбласти

#КонецЕсли
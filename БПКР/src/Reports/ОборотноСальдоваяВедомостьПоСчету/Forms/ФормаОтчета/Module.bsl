#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания; 

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	
	ИБФайловая = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	ПодключитьОбработчикОжидания = Не ИБФайловая И ЗначениеЗаполнено(ИдентификаторЗадания);
	Если ПодключитьОбработчикОжидания Тогда		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	
	ОбновитьИсходныеЗначения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ПередЗакрытием(ЭтотОбъект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, Отчет.РежимРасшифровки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	БухгалтерскиеОтчетыКлиент.ПриЗакрытии(ЭтотОбъект, ЗавершениеРаботы);

КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	Если Не КомпоновщикИнициализирован Тогда
		ПользовательскиеНастройки = ПоместитьВоВременноеХранилище(Настройки, УникальныйИдентификатор);
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
	
	Если Не КомпоновщикИнициализирован И ОбщегоНазначения.ЭтоВебКлиент() Тогда
		ИнициализацияКомпоновщикаНастроек();
		РазделыНастроек = Элементы.РазделыНастроек.ПодчиненныеЭлементы;
		Элементы.РазделыНастроек.ТекущаяСтраница = РазделыНастроек.ГруппаГруппировка;
	ИначеЕсли КомпоновщикИнициализирован Тогда
		ИзменениеСхемыКомпоновкиДанныхНаСервере();
	КонецЕсли;
	
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);
	ОбновитьИсходныеЗначения(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область Период

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", Отчет.НачалоПериода, Отчет.КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(Отчет, РезультатВыбора, "НачалоПериода,КонецПериода");
	
	ОбновитьТекстЗаголовка(ЭтотОбъект); 
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Результат

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ОбработкаРасшифровкиСтандартногоОтчета(ЭтотОбъект, Элемент, Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	// Не будем обрабатывать нажатие на правую кнопку мыши.
	// Покажем стандартное контекстное меню ячейки табличного документа.
	Расшифровка = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область Показатели

&НаКлиенте
Процедура ПоказательБУПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательВалютнаяСуммаПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательКоличествоПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутоеСальдоПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Группировка

&НаКлиенте
Процедура ПериодичностьПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПоСубсчетамПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломДобавления(ЭтотОбъект, Элемент, Отказ, Копирование, Родитель, Группа);  
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломИзменения(ЭтотОбъект, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Отборы

&НаКлиенте
Процедура СчетПриИзменении(Элемент)
	
	Если СчетИсходноеЗначение = Отчет.Счет Тогда
		Возврат;
	КонецЕсли;
	
	СчетПриИзмененииСервер();
	
	ОбновитьТекстЗаголовка(ЭтотОбъект); 
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПриИзменении(ЭтотОбъект, Элемент);
	
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломДобавления(ЭтотОбъект, Элемент, Отказ, Копирование, Родитель, Группа);

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломИзменения(ЭтотОбъект, Элемент, Отказ);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокПараметров = ПолучитьПараметрыВыбораЗначенияОтбора();
	БухгалтерскиеОтчетыКлиент.ОтборыПравоеЗначениеНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка, СписокПараметров);
	
КонецПроцедуры

#КонецОбласти

#Область Организация

&НаКлиенте
Процедура ПолеОрганизацияПриИзменении(Элемент)
	
	Если ОрганизацияИсходноеЗначение = ПолеОрганизация Тогда
		Возврат;
	КонецЕсли;
	
	ОрганизацияИзменилась = Истина;
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияПриИзменении(Элемент, ПолеОрганизация, Отчет.Организация);
	
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	Если КомпоновщикИнициализирован Тогда
		БухгалтерскиеОтчетыКлиент.ОрганизацияПриИзменении(ЭтотОбъект, Элемент);
	КонецЕсли;
	
	ОбновитьИсходныеЗначения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка,
		ПолеОрганизация, СоответствиеОрганизаций);
		
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка, 
		СоответствиеОрганизаций, Отчет.Организация);
	
КонецПроцедуры

#КонецОбласти

#Область ДополнительныеПоля

&НаКлиенте
Процедура РазмещениеДополнительныхПолейПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломДобавления(ЭтотОбъект, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломИзменения(ЭтотОбъект, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Сортировка

&НаКлиенте
Процедура СортировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломДобавления(ЭтотОбъект, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломИзменения(ЭтотОбъект, Элемент, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область Оформление

&НаКлиенте
Процедура МакетОформленияПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Отчет.КомпоновщикНастроек.Настройки, "МакетОформления", МакетОформления);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЗаголовокПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьПодвалПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЕдиницуИзмеренияПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьКолонтитулы(Команда)
	Перем Настройки;
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("НастройкиКолонтитулов", Настройки);
	
	ОткрытьФорму("ОбщаяФорма.НастройкаКолонтитулов",
		Новый Структура("Настройки", Настройки),
		ЭтотОбъект,
		УникальныйИдентификатор,,,
		Новый ОписаниеОповещения("ЗапомнитьНастройкиКолонтитулов", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

// Обработчик закрытия общей формы НастройкаКолонтитулов.
//  См. Синтакс-помощник: ОткрытьФорму - ОписаниеОповещенияОЗакрытии.
//
&НаКлиенте
Процедура ЗапомнитьНастройкиКолонтитулов(Настройки, ДополнительныеПараметры) Экспорт 
	ПредыдущиеНастройки = Неопределено;
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("НастройкиКолонтитулов", ПредыдущиеНастройки);
	
	Если Настройки <> ПредыдущиеНастройки Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("НастройкиКолонтитулов", Настройки);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
		
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		ОткрытьНастройки();
	Иначе	
		СкрытьНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	СкрытьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	
	Если Не КомпоновщикИнициализирован Тогда
		ИнициализацияКомпоновщикаНастроек();
	КонецЕсли;
	
	ОткрытьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочте(Команда)
	
	БухгалтерскиеОтчетыКлиент.ОтправитьОтчет(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура РаскрытьНаВесьЭкран(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Заголовок", Заголовок);
	ПараметрыОткрытия.Вставить("Результат", АдресХранилищаРезультата());

	ОткрытьФорму("ОбщаяФорма.ФормаПредпросмотраОтчета", ПараметрыОткрытия, ЭтотОбъект);
	ТекущийЭлемент = Элементы.Сформировать;
	
КонецПроцедуры

#Область ОбработчикиКомандРасчетаПоказателей

&НаКлиенте
Процедура РассчитатьСумму(Команда)
	РассчитатьПоказатели(Команда.Имя);
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьКоличество(Команда)
	РассчитатьПоказатели(Команда.Имя);
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСреднее(Команда)
	РассчитатьПоказатели(Команда.Имя);
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьМинимум(Команда)
	РассчитатьПоказатели(Команда.Имя);
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьМаксимум(Команда)
	РассчитатьПоказатели(Команда.Имя);
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьВсеПоказатели(Команда)
	УстановитьВидимостьПоказателей(Не Элементы.РассчитатьВсеПоказатели.Пометка);
КонецПроцедуры

&НаКлиенте
Процедура СвернутьПоказатели(Команда)
	УстановитьВидимостьПоказателей(Ложь);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПодготовитьПараметрыОтчета()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация"                      , Отчет.Организация);
	ПараметрыОтчета.Вставить("НачалоПериода"                    , Отчет.НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода"                     , Отчет.КонецПериода);
	ПараметрыОтчета.Вставить("ПоказательБУ"                     , Отчет.ПоказательБУ);
	ПараметрыОтчета.Вставить("ПоказательВалютнаяСумма"          , Отчет.ПоказательВалютнаяСумма);
	ПараметрыОтчета.Вставить("ПоказательКоличество"             , Отчет.ПоказательКоличество);
	ПараметрыОтчета.Вставить("РазвернутоеСальдо"                , Отчет.РазвернутоеСальдо);
	ПараметрыОтчета.Вставить("РазмещениеДополнительныхПолей"    , Отчет.РазмещениеДополнительныхПолей);
	ПараметрыОтчета.Вставить("Периодичность"                    , Отчет.Периодичность);
	ПараметрыОтчета.Вставить("Счет"                             , Отчет.Счет);
	ПараметрыОтчета.Вставить("ПоСубсчетам"                      , Отчет.ПоСубсчетам);
	ПараметрыОтчета.Вставить("Группировка"                      , Отчет.Группировка.Выгрузить());
	ПараметрыОтчета.Вставить("ДополнительныеПоля"               , Отчет.ДополнительныеПоля.Выгрузить());
	ПараметрыОтчета.Вставить("РежимРасшифровки"                 , Отчет.РежимРасшифровки);
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок"                , ВыводитьЗаголовок);
	ПараметрыОтчета.Вставить("ВыводитьПодвал"                   , ВыводитьПодвал);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"                , ДанныеРасшифровки);
	ПараметрыОтчета.Вставить("МакетОформления"                  , МакетОформления);
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных"            , ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных));
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"              , БухгалтерскиеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтотОбъект));
	ПараметрыОтчета.Вставить("НастройкиКомпоновкиДанных"        , Отчет.КомпоновщикНастроек.ПолучитьНастройки());
	ПараметрыОтчета.Вставить("НаборПоказателей"                 , Отчеты[ПараметрыОтчета.ИдентификаторОтчета].ПолучитьНаборПоказателей());
	ПараметрыОтчета.Вставить("ОтветственноеЛицо"                , Справочники.ВидыОтветственныхЛиц.ГлавныйБухгалтер);
	ПараметрыОтчета.Вставить("ВыводитьЕдиницуИзмерения"         , ВыводитьЕдиницуИзмерения);
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	ЗаголовокОтчета = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Оборотно-сальдовая ведомость по счету %1%2'"), Отчет.Счет,
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода));
	
	Если ЗначениеЗаполнено(Отчет.Организация) И Форма.ИспользуетсяНесколькоОрганизаций Тогда
		ЗаголовокОтчета = ЗаголовокОтчета + " " + БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(Отчет.Организация);
	КонецЕсли;
	
	Форма.Заголовок = ЗаголовокОтчета;

КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗапрещенныеПоля(Режим = "") Экспорт
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	СписокПолей.Добавить("Показатели");
	СписокПолей.Добавить("Период");
	
	Если Режим = "Выбор" Тогда
		Для Каждого ДоступноеПоле Из Отчет.КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
			Если ДоступноеПоле.Ресурс Тогда
				СписокПолей.Добавить(Строка(ДоступноеПоле.Поле));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Отчет.Счет) Тогда 
		КоличествоСубконто = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Отчет.Счет).КоличествоСубконто;
	Иначе
		КоличествоСубконто = 0;
	КонецЕсли;
	Для Индекс = КоличествоСубконто + 1 По 3 Цикл
		СписокПолей.Добавить("Субконто" + Индекс);
	КонецЦикла;
	
	Если Не Отчет.ПоказательВалютнаяСумма Тогда
		СписокПолей.Добавить("Валюта");
	КонецЕсли;
	
	Если Режим = "Группировка" Тогда
		СписокПолей.Добавить("Счет");
		СписокПолей.Добавить("СальдоНаНачалоПериода");
		СписокПолей.Добавить("ОборотыЗаПериод");
		СписокПолей.Добавить("СальдоНаКонецПериода");
	ИначеЕсли Режим = "Выбор" Тогда
		СписокПолей.Добавить("СальдоНаНачалоПериода");
		СписокПолей.Добавить("ОборотыЗаПериод");
		СписокПолей.Добавить("СальдоНаКонецПериода");
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаСервере
Функция СформироватьОтчетНаСервере() Экспорт
	
	Если Не КомпоновщикИнициализирован Тогда
		ИнициализацияКомпоновщикаНастроек();
	КонецЕсли;
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Новый Структура("ЗаданиеВыполнено, ОтказПроверкиЗаполнения", Истина, Истина);
	КонецЕсли;
	
	ДополнительныеСвойства = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодвал);
	Отчет.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки              = "";
	Отчет.КомпоновщикНастроек.Настройки.Порядок.ИдентификаторПользовательскойНастройки            = "";
	Отчет.КомпоновщикНастроек.Настройки.УсловноеОформление.ИдентификаторПользовательскойНастройки = "";
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет",
			ПараметрыОтчета,
			БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтотОбъект));
			
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Процедура СчетПриИзмененииСервер()
	
	Если Не КомпоновщикИнициализирован Тогда
		ИнициализацияКомпоновщикаНастроек();
	Иначе
		
		Если Не Отчет.РежимРасшифровки Тогда
			
			БухгалтерскиеОтчеты.СохранитьОписаниеНастроек(ЭтотОбъект, СчетИсходноеЗначение);
			
		КонецЕсли;
		
		ИзменениеСхемыКомпоновкиДанныхНаСервере();
		
	КонецЕсли;
	
	БухгалтерскиеОтчеты.ПрочитатьОписаниеНастроек(ЭтотОбъект, Отчет.Счет);
	
	УправлениеФормой(ЭтотОбъект);
	
	ОбновитьИсходныеЗначения(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ИзменениеСхемыКомпоновкиДанныхНаСервере() Экспорт
	
	Схема = ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных);
	Если ЗначениеЗаполнено(Отчет.Счет) Тогда
		
		СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Отчет.Счет);
		КоличествоСубконто = СвойстваСчета.КоличествоСубконто;
		
		ИмяПоляПрефикс = "Субконто";
		
		ПараметрыОС = Новый Структура("ИндексСубконто, ЗаголовокСубконто", 0, "");
		
		// Изменение представления и наложения ограничения типа значения.
		Для Каждого НаборДанных Из Схема.НаборыДанных.ОсновнойНаборДанных.Элементы Цикл
			Для Индекс = 1 По КоличествоСубконто Цикл
				Поле = НаборДанных.Поля.Найти(ИмяПоляПрефикс + Индекс);
				Если Поле <> Неопределено Тогда
					ТипЗначения = СвойстваСчета["ВидСубконто" + Индекс + "ТипЗначения"];
					Поле.ТипЗначения = ТипЗначения;
					Поле.Заголовок   = СвойстваСчета["ВидСубконто" + Индекс + "Наименование"];
					СтрокиСубконто = Отчет.Группировка.НайтиСтроки(Новый Структура("Поле", Поле.Поле));
					Для Каждого СтрокаГруппировки Из СтрокиСубконто Цикл
						
						СтрокаГруппировки.Представление = Поле.Заголовок;
						
					КонецЦикла;
					
				КонецЕсли;
				
				Если Поле.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ОсновныеСредства")) Тогда
					ПараметрыОС.ИндексСубконто    = Индекс;
					ПараметрыОС.ЗаголовокСубконто = Поле.Заголовок;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Отчет.КомпоновщикНастроек, "Счет", Отчет.Счет);
		
		БухгалтерскиеОтчеты.ОбработатьНаборДанныхСвязаннойИнформации(Схема, "ДанныеОС"     , ПараметрыОС);
		
		СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(Схема, СхемаКомпоновкиДанных);
		Отчет.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкамиПоУмолчанию(ЗаполняемыеНастройки) Экспорт
	
	Перем ЗаполнятьКоллекцию;

	Если ЗаполняемыеНастройки.Свойство("Отбор", ЗаполнятьКоллекцию) И ЗаполнятьКоллекцию Тогда

		БухгалтерскиеОтчеты.ПреобразоватьОтборыПоСчету(Отчет.КомпоновщикНастроек.Настройки.Отбор,
			СчетИсходноеЗначение, Отчет.Счет);
			
		Если ЗаполняемыеНастройки.Количество() = 1 Тогда
			// Заполнение отборов может вызываться отдельно из процедуры БухгалтерскиеОтчеты.ПрочитатьОписаниеНастроек() .
			// В этом случае нет необходимости инициализировать лишние переменные (например, ДанныеСчета).
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Отчет.Счет);
	КоличествоСубконто = ДанныеСчета.КоличествоСубконто;

	ИмяПоляПрефикс = "Субконто";
	
	Если ЗаполняемыеНастройки.Свойство("Показатели", ЗаполнятьКоллекцию) И ЗаполнятьКоллекцию Тогда
		
		// Управление показателями.
		Отчет.ПоказательБУ            = Истина;
		Отчет.ПоказательВалютнаяСумма = ДанныеСчета.Валютный;
		Отчет.ПоказательКоличество    = ДанныеСчета.Количественный;
		
		// Если счет не активно-пассивный, сбросим флаг развернутое сальдо.
		Если ДанныеСчета.Вид <> ВидСчета.АктивноПассивный Тогда
			
			Отчет.РазвернутоеСальдо = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;

	Если ЗаполняемыеНастройки.Свойство("Группировка", ЗаполнятьКоллекцию) И ЗаполнятьКоллекцию Тогда
		
		// Добавление группировок с соответствии с выбранным счетом.
		Отчет.Группировка.Очистить();
		
		// По умолчанию будет включено только первое субконто счета.
		Использование = Истина;
		
		Для Индекс = 1 По КоличествоСубконто Цикл
			НоваяСтрока = Отчет.Группировка.Добавить();
			Поле = Отчет.КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ИмяПоляПрефикс + Индекс));
			НоваяСтрока.Поле           = Поле.Поле;
			НоваяСтрока.Использование  = Использование;
			НоваяСтрока.Представление  = Поле.Заголовок;
			НоваяСтрока.ТипГруппировки = 0;	
			
			Использование = Ложь;

			Если ДанныеСчета.Валютный Тогда
				НоваяСтрока = Отчет.Группировка.Добавить();
				НоваяСтрока.Поле = "Валюта";
				НоваяСтрока.Использование = Использование;
				НоваяСтрока.Представление = "Валюта";
				НоваяСтрока.ТипГруппировки = 0;
			КонецЕсли;
		КонецЦикла;	
		
	КонецЕсли;
	
	Если ЗаполняемыеНастройки.Свойство("ДополнительныеПоля", ЗаполнятьКоллекцию) И ЗаполнятьКоллекцию Тогда
		БухгалтерскиеОтчетыВызовСервера.ЗаполнитьДополнительныеПоляИзНастроек(Отчет.КомпоновщикНастроек, Отчет.ДополнительныеПоля, Отчет.Группировка);
	КонецЕсли;
	
	Если ЗаполняемыеНастройки.Свойство("Порядок", ЗаполнятьКоллекцию) И ЗаполнятьКоллекцию Тогда
		Порядок = Отчет.КомпоновщикНастроек.Настройки.Порядок;
		БухгалтерскиеОтчеты.УдалитьНедоступныеПоля(Порядок.Элементы, Порядок.ДоступныеПоляПорядка, КоличествоСубконто);
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Отчет    = Форма.Отчет;
	Элементы = Форма.Элементы;
	
	ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Отчет.Счет);
	
	Форма.ПредставлениеТекущихПользовательскихНастроек = ДанныеСчета.Код + " " + ДанныеСчета.Наименование;
	
	Элементы.ПоказательВалютнаяСумма.Доступность = ДанныеСчета.Валютный ИЛИ ДанныеСчета.ЗапретитьИспользоватьВПроводках;
	Элементы.ПоказательКоличество.Доступность    = ДанныеСчета.Количественный;
	
	Элементы.РазвернутоеСальдо.Доступность = ДанныеСчета.Вид = ВидСчета.АктивноПассивный;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИсходныеЗначения(Форма)
	
	Отчет    = Форма.Отчет;
	
	Форма.СчетИсходноеЗначение        = Отчет.Счет;
	Форма.ОрганизацияИсходноеЗначение = Форма.ПолеОрганизация;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Результат = РезультатВыполнения.Результат;	

	ДанныеРасшифровки = РезультатВыполнения.ДанныеРасшифровки;
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ДополнительныеСвойства = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 

			ЗагрузитьПодготовленныеДанные();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
					
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыВыбораЗначенияОтбора() Экспорт
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Дата"              , Отчет.КонецПериода);
	СписокПараметров.Вставить("СчетУчета"         , Отчет.Счет);
	СписокПараметров.Вставить("Номенклатура"      , Неопределено);
	СписокПараметров.Вставить("Склад"             , Неопределено);
	СписокПараметров.Вставить("Организация"       , Отчет.Организация);
	СписокПараметров.Вставить("Контрагент"        , Неопределено);
	СписокПараметров.Вставить("ДоговорКонтрагента", Неопределено);
	
	Возврат СписокПараметров;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	Перем ТекущаяКоманда;
	
	КомандыПоказателей = КомандыПоказателей();
	Для Каждого Команда Из КомандыПоказателей Цикл 
		Если Элементы[Команда.Ключ].Пометка Тогда 
			ТекущаяКоманда = Команда.Ключ;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	РассчитатьПоказатели(ТекущаяКоманда);
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура ОткрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияКомпоновщикаНастроек()
	
	БухгалтерскиеОтчетыВызовСервера.ИнициализацияКомпоновщикаНастроек(ЭтотОбъект, ОрганизацияИзменилась);

	ИзменениеСхемыКомпоновкиДанныхНаСервере();
	
КонецПроцедуры

&НаСервере
Функция АдресХранилищаРезультата()
	
	Возврат ПоместитьВоВременноеХранилище(Результат, УникальныйИдентификатор);
	
КонецФункции

#Область РасчетПоказателейВыделенныхЯчеек

// Выполняет расчет и вывод показателей выделенных областей ячеек табличного документа.
//
// Параметры:
//  ТекущаяКоманда - Строка - имя команды расчета показателя, например, "РассчитатьСумму".
//                      Определяет, какой показатель является основным.
//
&НаКлиенте
Процедура РассчитатьПоказатели(ТекущаяКоманда = "РассчитатьСумму")
	// Расчет показателей.
	ПараметрыРасчета = БухгалтерскиеОтчетыКлиент.ПараметрыРасчетаПоказателейЯчеек(Результат);
	Если ПараметрыРасчета.РассчитатьНаСервере Тогда 
		РасчетныеПоказатели = РасчетныеПоказателиСервер(ПараметрыРасчета);
	Иначе
		РасчетныеПоказатели = ОбщегоНазначенияСлужебныйКлиентСервер.РасчетныеПоказателиЯчеек(
			Результат, ПараметрыРасчета.ВыделенныеОбласти);
	КонецЕсли;
	
	// Установка значений показателей.
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РасчетныеПоказатели);
	
	// Переключение и форматирование показателей.
	КомандыПоказателей = КомандыПоказателей();
	Для Каждого Команда Из КомандыПоказателей Цикл 
		Элементы[Команда.Ключ].Пометка = Ложь;
		
		ЗначениеПоказателя = РасчетныеПоказатели[Команда.Значение];
		РазрядностьПоказателя = Мин(СтрДлина(Макс(ЗначениеПоказателя, -ЗначениеПоказателя) % 1) - 2, 4);
		
		Элементы[Команда.Значение].ФорматРедактирования = "ЧДЦ=" + РазрядностьПоказателя + "; ЧРГ=' '; ЧН=0";
	КонецЦикла;
	Элементы[ТекущаяКоманда].Пометка = Истина;
	
	// Вывод основного показателя.
	ТекущийПоказатель = КомандыПоказателей[ТекущаяКоманда];
	БыстрыйПоказатель = ЭтотОбъект[ТекущийПоказатель];
	Элементы.БыстрыйПоказатель.ФорматРедактирования = Элементы[ТекущийПоказатель].ФорматРедактирования;
	Элементы.ГруппаВидыПоказателей.Картинка = БиблиотекаКартинок[ТекущийПоказатель];
КонецПроцедуры

// Рассчитывает показатели числовых ячеек в табличном документе.
//  см. ОтчетыКлиентСервер.РасчетныеПоказателиЯчеек.
//
&НаСервере
Функция РасчетныеПоказателиСервер(ПараметрыРасчета)
	Возврат ОбщегоНазначенияСлужебныйКлиентСервер.РасчетныеПоказателиЯчеек(Результат, ПараметрыРасчета.ВыделенныеОбласти);
КонецФункции

// Определяет соответствие между командами расчета показателей и показателями.
//
// Возвращаемое значение:
//   Соответствие - Ключ - имя команды, Значение - имя показателя.
//
&НаКлиенте
Функция КомандыПоказателей()
	КомандыПоказателей = Новый Соответствие();
	КомандыПоказателей.Вставить("РассчитатьСумму", "Сумма");
	КомандыПоказателей.Вставить("РассчитатьКоличество", "Количество");
	КомандыПоказателей.Вставить("РассчитатьСреднее", "Среднее");
	КомандыПоказателей.Вставить("РассчитатьМинимум", "Минимум");
	КомандыПоказателей.Вставить("РассчитатьМаксимум", "Максимум");
	
	Возврат КомандыПоказателей;
КонецФункции

// Управляет признаком видимости панели расчетных показателей.
//
// Параметры:
//  Видимость - Булево - Признак включения / выключения видимости панели показателей.
//              См. также Синтакс-помощник: ГруппаФормы.Видимость.
//
&НаКлиенте
Процедура УстановитьВидимостьПоказателей(Видимость)
	Элементы.ОбластьПоказателей.Видимость = Видимость;
	Элементы.РассчитатьВсеПоказатели.Пометка = Видимость;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

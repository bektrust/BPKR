#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	
	Если НЕ ИнформационнаяБазаФайловая Тогда
		
		Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
			ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
		ИначеЕсли НЕ Отчет.РежимРасшифровки Тогда
			ПодключитьОбработчикОжидания("Подключаемый_СформироватьПриОткрытии", БухгалтерскиеОтчетыКлиент.ИнтервалЗапускаФормированияОтчетаПриОткрытии(), Истина);
		КонецЕсли;
		
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	
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
	
	БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервереВОтчетеРуководителю(ЭтотОбъект, Настройки);
	
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	
	Если ИнформационнаяБазаФайловая Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.УстановитьНастройкиПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияПриИзменении(Элемент, ПолеОрганизация, Отчет.Организация);
	
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ОрганизацияПриИзменении(ЭтотОбъект, Элемент);
	
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

/////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЯ РЕЗУЛЬТАТА

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

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ГРУППИРОВКА

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


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ОТБОРЫ

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


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ДОПОЛНИТЕЛЬНЫЕ ПОЛЯ

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


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ СОРТИРОВКА

&НаКлиенте
Процедура СортировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломДобавления(ЭтотОбъект, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломИзменения(ЭтотОбъект, Элемент, Отказ);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ОФОРМЛЕНИЕ

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

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ЗапуститьФормированиеОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	Элементы.СформироватьОтчет.КнопкаПоУмолчанию = Истина;
	СкрытьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	ОткрытьНастройки();
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочте(Команда)
	
	БухгалтерскиеОтчетыКлиент.ОтправитьОтчет(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРассылкуОтчета(Команда)
	
	ЗаполнитьНастройкиОтчетаДляРассылки();
	
	РассылкаОтчетовБПКлиент.НастроитьРассылкуИзОтчета(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РаскрытьНаВесьЭкран(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Заголовок", Заголовок);
	ПараметрыОткрытия.Вставить("Результат", АдресХранилищаРезультата());

	ОткрытьФорму("ОбщаяФорма.ФормаПредпросмотраОтчета", ПараметрыОткрытия, ЭтотОбъект);
	ТекущийЭлемент = Элементы.СформироватьОтчет;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьНастройкиПоУмолчанию(Команда)
	УстановитьНастройкиПоУмолчаниюНаСервере();
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
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

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Функция ПодготовитьПараметрыОтчетаНаСервере()
	
	МенеджерОтчета = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ЭтотОбъект.ИмяФормы);
	
	ПараметрыОтчета = МенеджерОтчета.ПустыеПараметрыКомпоновкиОтчета();
	
	ПараметрыОтчета.Период                            = Отчет.Период;
	ПараметрыОтчета.Организация                       = Отчет.Организация;
	ПараметрыОтчета.РазмещениеДополнительныхПолей     = Отчет.РазмещениеДополнительныхПолей;
	ПараметрыОтчета.Группировка                       = Отчет.Группировка.Выгрузить();
	ПараметрыОтчета.ДополнительныеПоля                = Отчет.ДополнительныеПоля.Выгрузить();
	
	ПараметрыОтчета.ВыводитьЗаголовок                 = ВыводитьЗаголовок;
	ПараметрыОтчета.ВыводитьПодвал                    = ВыводитьПодвал;
	ПараметрыОтчета.МакетОформления                   = МакетОформления;
	ПараметрыОтчета.РежимРасшифровки                  = Отчет.РежимРасшифровки;
	ПараметрыОтчета.ДанныеРасшифровки                 = ДанныеРасшифровки;
	ПараметрыОтчета.СхемаКомпоновкиДанных             = ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных);
	ПараметрыОтчета.ИдентификаторОтчета               = БухгалтерскиеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтотОбъект);
	ПараметрыОтчета.НастройкиКомпоновкиДанных         = Отчет.КомпоновщикНастроек.ПолучитьНастройки();
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	Название = ?(ЗначениеЗаполнено(Форма.ПредставлениеТекущегоВарианта), Форма.ПредставлениеТекущегоВарианта, "Остатки денежных средств");
	ЗаголовокОтчета = Название + " на " + Формат(Отчет.Период, "ДЛФ=D; ДП=...");
	
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
	СписокПолей.Добавить("Итог");
	
	Если Режим = "Группировка" ИЛИ Режим = "Выбор" Тогда		
		БухгалтерскиеОтчетыКлиент.ДобавитьПоляРесурсовВЗапрещенныеПоля(ЭтотОбъект, СписокПолей);
	КонецЕсли;
	
	Если Режим = "Группировка" Тогда
		СписокПолей.Добавить("Валюта");
	КонецЕсли;
	
	Если Режим = "Выбор" Тогда
		СписокПолей.Добавить("ВидДенежныхСредств");
		СписокПолей.Добавить("Валюта");
		СписокПолей.Добавить("Размещение");
	КонецЕсли;
	
	Если Режим = "Порядок"
		И Отчет.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.Элементы.Найти("Валюта") = Неопределено Тогда
		СписокПолей.Добавить("ВалютнаяСуммаОстаток");		
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаСервере
Функция СформироватьОтчетНаСервере() Экспорт
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено, ОтказПроверкиЗаполнения", Истина, Истина);
	КонецЕсли;
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодвал);

	ПараметрыОтчета = ПодготовитьПараметрыОтчетаНаСервере();
	
	Если ИнформационнаяБазаФайловая Тогда
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
		ЗагрузитьПодготовленныеДанныеНаСервере();
	КонецЕсли;
	
	Элементы.СформироватьОтчет.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанныеНаСервере()

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат         = РезультатВыполнения.Результат;
	ДанныеРасшифровки = РезультатВыполнения.ДанныеРасшифровки;
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ДополнительныеСвойства = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанныеНаСервере();
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

&НаКлиенте
Процедура ОткрытьНастройки()
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыВыбораЗначенияОтбора()
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Организация", Отчет.Организация);
	
	Возврат СписокПараметров;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_СформироватьПриОткрытии()
	
	ЗапуститьФормированиеОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьФормированиеОтчета()
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		ПоказатьНастройки("");
	Иначе	
		СкрытьНастройки();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкиОтчетаДляРассылки()
	
	РассылкаОтчетовБП.ЗаполнитьНастройкиОтчетаДляРассылки(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Функция АдресХранилищаРезультата()
	
	Возврат ПоместитьВоВременноеХранилище(Результат, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура УстановитьНастройкиПоУмолчаниюНаСервере()
	БухгалтерскиеОтчетыВызовСервера.УстановитьНастройкиПоУмолчанию(ЭтотОбъект);
КонецПроцедуры 

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

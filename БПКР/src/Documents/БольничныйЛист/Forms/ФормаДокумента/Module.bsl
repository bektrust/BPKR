#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
		
	// КопированиеСтрокТабличныхЧастей
	КопированиеТабличнойЧастиСервер.ПриСозданииНаСервере(Элементы, "СреднийЗаработок");
	КопированиеТабличнойЧастиСервер.ПриСозданииНаСервере(Элементы, "Начисления");
	// Конец КопированиеСтрокТабличныхЧастей
	
	// РаботаСФормами
	РаботаСФормамиСервер.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец РаботаСФормами
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом 
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	РассчитатьСреднийЗаработок();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// КопированиеСтрокТабличныхЧастей
	Если ИмяСобытия = "БуферОбменаТабличнаяЧастьКопированиеСтрок" Тогда
		КопированиеТабличнойЧастиКлиент.ОбработкаОповещения(Элементы, "СреднийЗаработок");
		КопированиеТабличнойЧастиКлиент.ОбработкаОповещения(Элементы, "Начисления");
	КонецЕсли;
	// Конец КопированиеСтрокТабличныхЧастей
КонецПроцедуры

// Процедура - обработчик события ПослеЗаписиНаСервере.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)	
	
	// РаботаСФормами
	РаботаСФормамиСервер.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец РаботаСФормами
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

// Процедура - обработчик события ПослеЗаписи.
//
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода Дата.
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	ПодключитьОбработчикОжидания("УстановитьПиктограммуКомментария", 0.1, Истина);
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ФизЛицо.
//
&НаКлиенте
Процедура ФизЛицоПриИзменении(Элемент)
	ФизЛицоПриИзмененииНаСервере();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ДатаНачала.
//
&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	РассчитатьДни();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ДатаОкончания.
//
&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	РассчитатьДни();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ДнейОрганизации.
//
&НаКлиенте
Процедура ДнейОрганизацииПриИзменении(Элемент)
	Объект.ДнейЗаСчетСФ = Макс(Объект.Дней - Объект.ДнейОрганизации, 0);
КонецПроцедуры

&НаКлиенте
Процедура СтажПриИзменении(Элемент)
	РасчетПроцентаБольничногоНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура МетодРасчетаПриИзменении(Элемент)
	РасчетПроцентаБольничногоНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Асинх Процедура Заполнить(Команда)
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.ФизЛицо) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнено поле ""Сотрудник"". Заполнение документа отменено.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.ФизЛицо",,Отказ)		
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.ГрафикРаботы) Тогда 
		ТекстСообщения = НСтр("ru = 'Не заполнено поле ""ГрафикРаботы"".'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.ГрафикРаботы",,Отказ)		
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(Объект.МетодРасчета) Тогда 
		ТекстСообщения = НСтр("ru = 'Не заполнено поле ""МетодРасчета"".'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.МетодРасчета",,Отказ)		
	КонецЕсли;	
	
	Если НЕ ПроверитьЗаполнениеМетодаРасчета() Тогда 
		ТекстСообщения = НСтр("ru = 'Не заполнены поля в ""Методе расчета"".'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.МетодРасчета",,Отказ)		
	КонецЕсли;	
	
	Если Отказ Тогда 
		Возврат
	КонецЕсли;	
	
	Если НЕ ЗаписатьДокументОтменивПроведение() Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Объект.СреднийЗаработок.Количество() > 0 Тогда     
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет очищена. Продолжить выполнение операции?'");
		Ответ = Ждать ВопросАсинх(ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
		
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;	
		
		Объект.СреднийЗаработок.Очистить();
	КонецЕсли; 
		
	ЗаполнитьТабличнуюЧастьНаСервере();
	РассчитатьСреднийЗаработок();
КонецПроцедуры

&НаКлиенте
Асинх Процедура Рассчитать(Команда)
	Отказ = Ложь;

	Если Объект.СреднийЗаработок.Количество() = 0  Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнена табличная часть ""Средний заработок"". Расчет документа отменен.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.Начисления",,Отказ)		
	КонецЕсли;
	
	РассчитатьСреднийЗаработок(Истина, Отказ);
	
	Если Отказ Тогда 
		Возврат
	КонецЕсли;	
	
	Если НЕ ЗаписатьДокументОтменивПроведение() Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Объект.Начисления.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет очищена. Продолжить выполнение операции?'");
		Ответ = Ждать ВопросАсинх(ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
		
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;	
		
		Объект.Начисления.Очистить();
	КонецЕсли;
	
	РассчитатьТабличнуюЧастьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НормыБольничныхЛистов(Команда)
	ОткрытьФорму("РегистрСведений.НормыБольничныхЛистов.ФормаСписка");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением)
	РазностьДат = БухгалтерскийУчетСервер.ПроверитьНомерДокумента(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("РазностьДат",	РазностьДат);
	
	Возврат СтруктураДанные;
КонецФункции // ПолучитьДанныеДатаПриИзменении()

// Процедура - Установить пиктограмму комментария.
//
&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

// Функция - Проверить заполнение метода расчета
// 
// Возвращаемое значение:
//  Истина - ошибок нет
//
&НаСервере
Функция ПроверитьЗаполнениеМетодаРасчета()
	Если НЕ (ЗначениеЗаполнено(Объект.МетодРасчета.НеполныеМесяцы)
		Или ЗначениеЗаполнено(Объект.МетодРасчета.ВидРасчетаОрганизация)
		Или ЗначениеЗаполнено(Объект.МетодРасчета.ВидРасчетаСФ)) Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	Возврат Истина;
КонецФункции // ПроверитьЗаполнениеМетодаРасчета()

// Заполняет документ данными по физлицу
//
&НаСервере
Процедура ФизЛицоПриИзмененииНаСервере()
	
	СведенияОСотруднике = ПроведениеРасчетовПоЗарплатеСервер.СведенияОСотруднике(ДатаДокумента, Объект.Организация, Объект.ФизЛицо); 
	ЗаполнитьЗначенияСвойств(Объект, СведенияОСотруднике, "Подразделение, Должность, ГрафикРаботы"); 
	
	// Стаж
	СведенияОСтаже = ПроведениеРасчетовПоЗарплатеСервер.СведенияОСтажеСотрудника(ДатаДокумента, Объект.Организация, Объект.ФизЛицо);
	Объект.КоличествоЛетСтажа  = СведенияОСтаже.Лет;
	
	РасчетПроцентаБольничногоНаСервере(); 
	
КонецПроцедуры // ЗаполнитьПоФизЛицу()

// Процедура - Рассчитать дни
//
&НаСервере
Процедура РассчитатьДни()
	// Всего дней
	КоличествоДней = ПроведениеРасчетовПоЗарплатеСервер.КоличествоДнейГрафикаРаботы(Объект.ГрафикРаботы, Объект.ДатаНачала, Объект.ДатаОкончания);
	Объект.Дней = КоличествоДней.КоличествоДнейРабочий + КоличествоДней.КоличествоДнейПредпраздничный;
	
	// Дней за счет организации и соц.фонда
	НормыБольничныхЛистов = ПроведениеРасчетовПоЗарплатеСервер.НормыБольничныхЛистов(Объект.КоличествоЛетСтажа);
	Объект.ДнейОрганизации = Мин(НормыБольничныхЛистов.ДнейОрганизации, Объект.Дней);
	Объект.ДнейЗаСчетСФ = Макс(Объект.Дней - Объект.ДнейОрганизации, 0);
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСреднийЗаработок(СообщатьОбОшибке = Ложь, Отказ = Ложь)
	// База начислений 
	РезультатСреднийЗаработок = Объект.СреднийЗаработок.Итог("Результат");  
	ОтработаноДнейСреднийЗаработок = Объект.СреднийЗаработок.Итог("ОтработаноДней"); 	
	
	// Расчет размера 
	РазмерСреднийЗаработок = 0;
	
	Если ОтработаноДнейСреднийЗаработок = 0 Тогда 
		Если СообщатьОбОшибке Тогда 
			ТекстСообщения = НСтр("ru = 'Нет отработанных дней в заданном периоде.'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.СреднийЗаработок",,Отказ);
		КонецЕсли;	
	Иначе 
		РазмерСреднийЗаработок = РезультатСреднийЗаработок / ОтработаноДнейСреднийЗаработок;
	КонецЕсли;	
КонецПроцедуры

// Функция возвращает результат возможности записи/отмены проведения документа перед Расчетом
//
// Параметры:
//  Действие - действие, при котором выполняется проверка
// Возвращаемое значение:
//   Булево - 
//
&НаКлиенте
Функция ЗаписатьДокументОтменивПроведение()
	Если Объект.Проведен Тогда
		ЗаписатьНаСервере(РежимЗаписиДокумента.ОтменаПроведения);		
	ИначеЕсли НЕ ЗначениеЗаполнено(Объект.Ссылка) Или Модифицированность Тогда 
		Объект.Дата = ДатаДокумента;
		ЗаписатьНаСервере(РежимЗаписиДокумента.Запись);		
	КонецЕсли;	
	
	Модифицированность = Ложь;

	Возврат НЕ Объект.Проведен И ЗначениеЗаполнено(Объект.Ссылка);
КонецФункции // ЗаписатьДокументОтменивПроведение()

&НаСервере
Процедура ЗаписатьНаСервере(Режим)
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.Записать(Режим);
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры // ЗаписатьНаСервере()

&НаСервере
Процедура ЗаполнитьТабличнуюЧастьНаСервере()
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗаполнитьТабличнуюЧасть();
	ЗначениеВРеквизитФормы(Документ, "Объект");
	Модифицированность = Истина;
КонецПроцедуры // ЗаполнитьТабличнуюЧастьНаСервере()

// Процедура рассчитывает табличную часть
//
&НаСервере
Процедура РассчитатьТабличнуюЧастьНаСервере()
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.РассчитатьТабличнуюЧасть(РазмерСреднийЗаработок);
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры // РассчитатьТабличнуюЧастьНаСервере()

&НаСервере
Процедура РасчетПроцентаБольничногоНаСервере()
	НормыБольничныхЛистов = ПроведениеРасчетовПоЗарплатеСервер.НормыБольничныхЛистов(Объект.КоличествоЛетСтажа);
	Объект.ПроцентБольничного = ?(Объект.МетодРасчета = Справочники.МетодыРасчетаБольничногоЛиста.ПособиеПоБеременности, НормыБольничныхЛистов.ПроцентБеременность, НормыБольничныхЛистов.Процент);
КонецПроцедуры

#КонецОбласти

#Область КопированиеСтрокТабличныхЧастей

&НаКлиенте
Процедура СреднийЗаработокКопироватьСтроки(Команда)
	
	КопироватьСтроки("СреднийЗаработок");
	
КонецПроцедуры

&НаКлиенте
Процедура СреднийЗаработокВставитьСтроки(Команда)
	
	ВставитьСтроки("СреднийЗаработок");
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияКопироватьСтроки(Команда)
	
	КопироватьСтроки("Начисления");
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияВставитьСтроки(Команда)
	
	ВставитьСтроки("Начисления");
	
КонецПроцедуры

&НаКлиенте
Процедура КопироватьСтроки(ИмяТЧ)
	
	Если КопированиеТабличнойЧастиКлиент.МожноКопироватьСтроки(Объект[ИмяТЧ], Элементы[ИмяТЧ].ТекущиеДанные) Тогда
		КоличествоСкопированных = 0;
		КопироватьСтрокиНаСервере(ИмяТЧ, КоличествоСкопированных);
		КопированиеТабличнойЧастиКлиент.ОповеститьПользователяОКопированииСтрок(КоличествоСкопированных);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСтроки(ИмяТЧ)
	
	КоличествоСкопированных = 0;
	КоличествоВставленных = 0;
	ВставитьСтрокиНаСервере(ИмяТЧ, КоличествоСкопированных, КоличествоВставленных);
	КопированиеТабличнойЧастиКлиент.ОповеститьПользователяОВставкеСтрок(КоличествоСкопированных, КоличествоВставленных);
	
КонецПроцедуры

&НаСервере
Процедура КопироватьСтрокиНаСервере(ИмяТЧ, КоличествоСкопированных)
	
	КопированиеТабличнойЧастиСервер.Копировать(Объект[ИмяТЧ], Элементы[ИмяТЧ].ВыделенныеСтроки, КоличествоСкопированных);
	
КонецПроцедуры

&НаСервере
Процедура ВставитьСтрокиНаСервере(ИмяТЧ, КоличествоСкопированных, КоличествоВставленных)
	
	КопированиеТабличнойЧастиСервер.Вставить(Объект, ИмяТЧ, Элементы, КоличествоСкопированных, КоличествоВставленных);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
     ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
     ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
 
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
     ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
     ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти




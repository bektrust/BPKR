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
	
	РезультатПроверки = ПроверитьВозможностьВнесенияКадровыхИзменений(Объект.Ссылка, Объект.Организация, Объект.ФизЛицо, Объект.ДатаНачала);
	ИзмененияВозможны = РезультатПроверки.ИзмененияВозможны;
	БлокирующийДокумент = РезультатПроверки.Регистратор;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();

	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
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
	// СтандартныеПодсистемы.ДатыЗапретаИзменений
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменений
	
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
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "КадровоеИзменение"
		И Параметр.Организация = Объект.Организация
		И Параметр.ФизЛицо = Объект.ФизЛицо
		// Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник <> УникальныйИдентификатор Тогда
		
		РезультатПроверки = ПроверитьВозможностьВнесенияКадровыхИзменений(Объект.Ссылка, Объект.Организация, Объект.ФизЛицо, Объект.ДатаНачала);
		ИзмененияВозможны = РезультатПроверки.ИзмененияВозможны;
		БлокирующийДокумент = РезультатПроверки.Регистратор;
		
		// Установить видимость и доступность элементов формы
		УстановитьВидимостьДоступностьЭлементов();
	КонецЕсли;	
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
	Оповестить("КадровоеИзменение", Новый Структура("Организация, ФизЛицо", Объект.Организация, Объект.ФизЛицо), ЭтотОбъект);
	
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
	
	РезультатПроверки = ПроверитьВозможностьВнесенияКадровыхИзменений(Объект.Ссылка, Объект.Организация, Объект.ФизЛицо, Объект.ДатаНачала);	
	ИзмененияВозможны = РезультатПроверки.ИзмененияВозможны;
	БлокирующийДокумент = РезультатПроверки.Регистратор;
	
	// Установить видимость и доступность элементов формы	
	УстановитьВидимостьДоступностьЭлементов();           
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

// Процедура - обработчик события ПриИзменении поля ввода Контрагент.
//
&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	Объект.НазначениеПлатежа = СформироватьНазначениеПлатежа(Объект.ЛицевойСчет, Объект.Контрагент);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ЛицевойСчет.
//
&НаКлиенте
Процедура ЛицевойСчетПриИзменении(Элемент)
	Объект.НазначениеПлатежа = СформироватьНазначениеПлатежа(Объект.ЛицевойСчет, Объект.Контрагент);
КонецПроцедуры

&НаКлиенте
Процедура ФизлицоПриИзменении(Элемент)
	РезультатПроверки = ПроверитьВозможностьВнесенияКадровыхИзменений(Объект.Ссылка, Объект.Организация, Объект.ФизЛицо, Объект.ДатаНачала);
	ИзмененияВозможны = РезультатПроверки.ИзмененияВозможны;
	БлокирующийДокумент = РезультатПроверки.Регистратор;

	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	РезультатПроверки = ПроверитьВозможностьВнесенияКадровыхИзменений(Объект.Ссылка, Объект.Организация, Объект.ФизЛицо, Объект.ДатаНачала);
	ИзмененияВозможны = РезультатПроверки.ИзмененияВозможны;
	БлокирующийДокумент = РезультатПроверки.Регистратор;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция - Проверить возможность внесения кадровых изменений
//
&НаСервереБезКонтекста
Функция ПроверитьВозможностьВнесенияКадровыхИзменений(ДокументСсылка, Организация, ФизЛицо, ДатаИзменений)
	Если ЗначениеЗаполнено(Организация)
		И ЗначениеЗаполнено(ФизЛицо)
		И ЗначениеЗаполнено(ДатаИзменений) Тогда
		Возврат СотрудникиФормы.ПроверитьВозможностьВнесенияКадровыхИзменений(ДокументСсылка, Организация, ФизЛицо, ДатаИзменений, Новый Структура("ПлановыеУдержания", Истина));
	Иначе 
		Возврат Новый Структура("ИзмененияВозможны, РегистраторПредставление, Регистратор, Подразделение, Должность, ДатаИзменений", Истина, "", Неопределено);
	КонецЕсли;	
КонецФункции 

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	Элементы.ГруппаСообщенияОНевозможностиИзмененияДокумента.Видимость = НЕ ИзмененияВозможны;	
	ТолькоПросмотр = НЕ ИзмененияВозможны;
КонецПроцедуры 

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

&НаСервереБезКонтекста
Функция СформироватьНазначениеПлатежа(ЛицевойСчет, Контрагент)
	НазначениеПлатежа = "";
	Если ЗначениеЗаполнено(ЛицевойСчет) 
		И ЗначениеЗаполнено(Контрагент) Тогда
		
		НазначениеПлатежа = СтрШаблон(НСтр("ru = 'Лицевой счет №%1 %2 - алименты'"), ЛицевойСчет, Контрагент.Наименование);
	КонецЕсли;
	
	Возврат НазначениеПлатежа;
КонецФункции

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
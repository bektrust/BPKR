#Область ОбработчикиСобытийФормы
	
// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресХранилищаНастройкиДинСпискаДляРеестра = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	// БП.ОтборыСписка
	РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список);
	УстановитьОтборПоОсновнойОрганизации();
	// Конец БП.ОтборыСписка
	
	// РаботаСФормами
	РаботаСФормамиСервер.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец РаботаСФормами
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Документы.ВедомостьДепонированнойЗарплаты);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события ПриЗакрытии.
//
&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если НЕ ЗавершениеРаботы Тогда
		// БП.ОтборыСписка
		СохранитьНастройкиОтборов();
		// Конец БП.ОтборыСписка
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "СозданиеДокументаОплатыИзВедомостиЗаработнойПлаты" Тогда 
		Элементы.Список.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события формы ОбработкаВыбора
//
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ТипЗнч(ИсточникВыбора) = Тип("ФормаКлиентскогоПриложения")
	И СтрНайти(ИсточникВыбора.ИмяФормы, "ФормаКалендаря") > 0 Тогда

		ОтборПериодРегистрации = КонецДня(ВыбранноеЗначение);
		БухгалтерскийУчетКлиент.ПриИзмененииПериодаРегистрации(ЭтаФорма);
		РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(Список, "ПериодРегистрации", ОтборПериодРегистрации, ЗначениеЗаполнено(ОтборПериодРегистрации));

	КонецЕсли;

КонецПроцедуры // ОбработкаВыбора()

// Процедура - обработчик события формы "ПриЗагрузкеДанныхИзНастроекНаСервере".
//
&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОтборПериодРегистрации = Настройки.Получить("ОтборПериодРегистрации"); 
	РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(Список, "ПериодРегистрации", ОтборПериодРегистрации, ЗначениеЗаполнено(ОтборПериодРегистрации));
	ОтображениеПериодаРегистрации = Формат(ОтборПериодРегистрации, "ДФ='MMMM yyyy'");

	Если ЗначениеЗаполнено(ОтборПериодРегистрации) Тогда
		РаботаСОтборами.СвернутьРазвернутьОтборыНаСервере(ЭтотОбъект, Истина);
	КонецЕсли;

КонецПроцедуры // ПриЗагрузкеДанныхИзНастроекНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРеквизитовОтборов
	
&НаКлиенте
// Процедура обработчик события регулирования поля ПериодРегистрации
//
Процедура ОтборПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	БухгалтерскийУчетКлиент.ПриРегулированииПериодаРегистрации(ЭтаФорма, Направление);
	БухгалтерскийУчетКлиент.ПриИзмененииПериодаРегистрации(ЭтаФорма);
	РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(Список, "ПериодРегистрации", ОтборПериодРегистрации, ЗначениеЗаполнено(ОтборПериодРегистрации));
	
КонецПроцедуры //ОтборПериодРегистрацииРегулирование()

&НаКлиенте
// Процедура обработчик события начала выбора поля ПериодРегистрации
//
Процедура ОтборПериодРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка	 = Ложь;
	
	ДатаКалендаряПриОткрытии = ?(ЗначениеЗаполнено(ОтборПериодРегистрации), ОтборПериодРегистрации, БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьТекущуюДатаСеанса());
	
	ОткрытьФорму("ОбщаяФорма.ФормаКалендаря", БухгалтерскийУчетКлиент.ПолучитьПараметрыОткрытияФормыКалендаря(ДатаКалендаряПриОткрытии), ЭтаФорма);
	
КонецПроцедуры //ОтборПериодРегистрацииНачалоВыбора()

&НаКлиенте
// Процедура обработчик события очистки данных поля ПериодРегистрации
//
Процедура ОтборПериодРегистрацииОчистка(Элемент, СтандартнаяОбработка)
	
	ОтборПериодРегистрации = Неопределено;
	БухгалтерскийУчетКлиент.ПриИзмененииПериодаРегистрации(ЭтаФорма);
	РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(Список, "ПериодРегистрации", ОтборПериодРегистрации, ЗначениеЗаполнено(ОтборПериодРегистрации));
	
КонецПроцедуры //ОтборПериодРегистрацииОчистка()

&НаКлиенте
Процедура ОтборСотрудникОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Зарплата.ФизЛицо", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Организация", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#Область МеткиОтборов

&НаСервере
Процедура УстановитьОтборПоОсновнойОрганизации()

	Если Справочники.Организации.ИспользуетсяНесколькоОрганизаций() Тогда
		ОсновнаяОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
		Если ЗначениеЗаполнено(ОсновнаяОрганизация) Тогда 
			УстановитьМеткуИОтборСписка("Организация", Элементы.ОтборОрганизация.Родитель.Имя, ОсновнаяОрганизация);
		КонецЕсли;	
	Иначе
		УдаляемыеМетки = Новый СписокЗначений;
		Для Каждого Элемент Из Элементы.ОтборОрганизация.Родитель.ПодчиненныеЭлементы Цикл 
			Если СтрНайти(Элемент.Имя, "Метка_") > 0 Тогда 
				МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_")+1);
				УдалитьМеткуОтбора(МеткаИД);
			КонецЕсли;	
		КонецЦикла;	
		
		УдалитьМеткиОтбора(УдаляемыеМетки);
		ОбновитьЭлементыМеток();
	КонецЕсли;
	
КонецПроцедуры
	
&НаСервере
Процедура УстановитьМеткуИОтборСписка(ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения="")
	
	Если ПредставлениеЗначения = "" Тогда
		ПредставлениеЗначения = Строка(ВыбранноеЗначение);
	КонецЕсли; 
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения);
	РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, Список, ИмяПоляОтбораСписка);
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_")+1);
	УдалитьМеткуОтбора(МеткаИД);	
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД)
	
	РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, Список, МеткаИД);

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборов()
	
	РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
		
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьОтборыНажатие(Элемент)
	УдаляемыеМетки = Новый СписокЗначений;
	Для МеткаИД = 0 По ДанныеМеток.Количество()-1 Цикл
		УдаляемыеМетки.Добавить(МеткаИД);
	КонецЦикла;
	
	УдалитьМеткиОтбора(УдаляемыеМетки);
	ОбновитьЭлементыМеток();
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткиОтбора(Метки)
	
	РаботаСОтборами.УдалитьМеткиОтбораСервер(ЭтотОбъект, Список, Метки);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыМеток()
	
	РаботаСОтборами.ОбновитьЭлементыМеток(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

&НаСервере
Процедура НастройкиДинамическогоСписка()
	
	Отчеты.РеестрДокументов.НастройкиДинамическогоСписка(ЭтотОбъект);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Если СтрНачинаетсяС(Команда.Имя, "ПодменюПечатьОбычное_Реестр") Тогда
		НастройкиДинамическогоСписка();
	КонецЕсли;
	
    ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

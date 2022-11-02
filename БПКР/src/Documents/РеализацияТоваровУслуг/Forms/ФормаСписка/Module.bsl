
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
	
	// РегулярныеРТУ 
	НадписьЗапланировано = НадписьЗапланировано();
	Элементы.НадписьЗапланировано.Видимость = ЗначениеЗаполнено(НадписьЗапланировано);
	// Конец РегулярныеРТУ
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Документы.РеализацияТоваровУслуг);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчета.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, "Список");
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета

КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// РегулярныеРТУ 
	Если ИмяСобытия = "Запись_ПравилаРегулярныхРеализацийТоваровУслуг"
		Или ИмяСобытия = "Запись_РегулярныеРеализацииТоваровУслуг"
		Или ИмяСобытия = "Запись_РеализацияТоваровУслуг" И Параметр.Свойство("ВведенДокументПоПравилу") Тогда
		
		НадписьЗапланировано = НадписьЗапланировано();
		Элементы.НадписьЗапланировано.Видимость = (НадписьЗапланировано <> "");		
	КонецЕсли;
	// Конец РегулярныеРТУ
	
КонецПроцедуры

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

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьРеализацияТовары(Команда)
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийРеализацияТоваров.Товары"));
	ОткрытьФорму("Документ.РеализацияТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРеализацияУслуги(Команда)
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийРеализацияТоваров.Услуги"));
	ОткрытьФорму("Документ.РеализацияТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРеализацияТоварыУслугиОС(Команда)
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийРеализацияТоваров.ТоварыУслуги"));
	ОткрытьФорму("Документ.РеализацияТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРеализацияОсновныеСредства(Команда)
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийРеализацияТоваров.ОсновныеСредства"));
	ОткрытьФорму("Документ.РеализацияТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчета.ПриПолученииДанныхНаСервере(Настройки, Строки);
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРеквизитовОтборов

&НаКлиенте
Процедура ОтборКонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Контрагент", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборНоменклатураОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Товары.Номенклатура", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура ОтборОСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("ОС.ОсновноеСредство", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборНоменклатураУслугаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Услуги.Номенклатура", Элемент.Родитель.Имя, ВыбранноеЗначение);
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

&НаКлиенте
Процедура ОтборВалютаДокументаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("ВалютаДокумента", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПолучитьСтруктуруПараметровФормы(ВидОперации)

	СтруктураПараметров = Новый Структура;
	
	ЗначенияЗаполнения = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
	Если ЗначениеЗаполнено(ВидОперации) Тогда
		ЗначенияЗаполнения.Вставить("ВидОперации", ВидОперации);
	КонецЕсли;
	
	СтруктураПараметров.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Возврат СтруктураПараметров;
	
КонецФункции

// СтандартныеПодсистемы.КонтрольВеденияУчета
&НаКлиенте
Процедура Подключаемый_Выбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка) Экспорт
    КонтрольВеденияУчетаКлиент.ОткрытьОтчетПоПроблемамИзСписка(ЭтотОбъект, "Список", Поле, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.КонтрольВеденияУчета

#КонецОбласти

#Область ОбработчикиБиблиотек

&НаСервере
Процедура НастройкиДинамическогоСписка()
	
	Отчеты.РеестрДокументов.НастройкиДинамическогоСписка(ЭтотОбъект);
	
КонецПроцедуры

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

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

#Область РегулярныеРТУ

&НаКлиенте
Процедура НадписьЗапланированоОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФорму("Справочник.ПравилаРегулярныхРеализацийТоваровУслуг.ФормаСписка",, ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НадписьЗапланировано()
	
	ДанныеДляНадписи = Справочники.ПравилаРегулярныхРеализацийТоваровУслуг.ДанныеДляНадписиЗапланировано();
	
	КоличествоЗапланировано = ДанныеДляНадписи.КоличествоЗапланировано;
	КоличествоПросрочено    = ДанныеДляНадписи.КоличествоПросрочено;
	ДатаСледующего          = ДанныеДляНадписи.ДатаСледующего;
	ОсталосьДней            = ДанныеДляНадписи.ОсталосьДней;
	
	Если КоличествоЗапланировано = 0 Тогда
		Возврат "";
	КонецЕсли;
	
	ЭлементыНадписи = Новый Массив;
	
	Если КоличествоПросрочено > 0 Тогда
		ЦветСсылки = ЦветаСтиля.ПросроченныеДанныеЦвет;
	Иначе 
		ЦветСсылки = ЦветаСтиля.ЦветГиперссылки;
	КонецЕсли;
	
	ЭлементыНадписи.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Периодические реализации'"),, ЦветСсылки,, "Ссылка"));
	ЭлементыНадписи.Добавить(": ");
	
	Если КоличествоЗапланировано <> КоличествоПросрочено Тогда
		
		ПредметИсчисления = НСтр("ru = ';%1 запланирован;;%1 запланировано;%1 запланировано;%1 запланировано'");
		
		ЭлементыНадписи.Добавить(
			СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПредметИсчисления, КоличествоЗапланировано));
		
		Если КоличествоПросрочено > 0 Тогда
			ЭлементыНадписи.Добавить(", из них ");
		КонецЕсли;
		
	КонецЕсли;
	
	Если КоличествоПросрочено > 0 Тогда
		
		ПредметИсчисления = НСтр("ru = ';%1 просрочен;;%1 просрочено;%1 просрочено;%1 просрочено'");
		
		ЭлементыНадписи.Добавить(
			СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПредметИсчисления, КоличествоПросрочено));
		
	Иначе
		
		ЭлементыНадписи.Добавить(", ");
		
		Если КоличествоЗапланировано <> 1 Тогда
			ЭлементыНадписи.Добавить(НСтр("ru = 'следующий '"));
		КонецЕсли;
		
		ЭлементыНадписи.Добавить(Формат(ДатаСледующего, "ДЛФ=DD"));
		
		Если ОсталосьДней = 0 Тогда
			
			ЭлементыНадписи.Добавить(Нстр("ru = ' (Сегодня)'"));
			
		ИначеЕсли ОсталосьДней = 1 Тогда
			
			ЭлементыНадписи.Добавить(Нстр("ru = ' (Завтра)'"));
			
		ИначеЕсли ОсталосьДней < 8 Тогда
			
			ПараметрыПредметаИсчисления = НСтр("ru = ';%1 день; ;%1 дня;%1 дней;%1 дня'");
			НадписьДней = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПараметрыПредметаИсчисления, ОсталосьДней);
			
			ЭлементыНадписи.Добавить(СтрШаблон(Нстр("ru = ' (осталось %1)'"), НадписьДней));
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Новый ФорматированнаяСтрока(ЭлементыНадписи);
	
КонецФункции

#КонецОбласти


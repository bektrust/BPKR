#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если НЕ ЗначениеЗаполнено(Объект.ЕдиницаИзмерения) И ЗначениеЗаполнено(Объект.Родитель) Тогда
		Объект.ЕдиницаИзмерения = Объект.Родитель.ЕдиницаИзмерения;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ЕдиницаИзмерения) Тогда
		Штука = Справочники.КлассификаторЕдиницИзмерения.НайтиПоНаименованию("шт", Истина);
		Если НЕ Штука = Неопределено Тогда
			Объект.ЕдиницаИзмерения = Штука;
		КонецЕсли;
	КонецЕсли;
	
	Родитель = Объект.Родитель;
	
	Если Объект.Ссылка.Пустая() Тогда
		ОтобразитьОсновнуюСпецификацию();
	КонецЕсли;
	
	ОтобразитьСчетУчета();
	
	НастроитьЭлементыУправленияЦенами();
	
	УстановитьФункциональныеОпцииФормы();

	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.РаботаСФайлами
	ПараметрыГиперссылки = РаботаСФайлами.ГиперссылкаФайлов();
	ПараметрыГиперссылки.Размещение = "КоманднаяПанель";
	
	ПараметрыПоля = РаботаСФайлами.ПолеФайла();
	ПараметрыПоля.Размещение  = "ГруппаКартинка";
	ПараметрыПоля.ПутьКДанным = "Объект.ФайлКартинки";
	ПараметрыПоля.ПутьКДаннымИзображения = "АдресКартинки";
	
	ДобавляемыеЭлементы = Новый Массив;
	ДобавляемыеЭлементы.Добавить(ПараметрыГиперссылки);
	ДобавляемыеЭлементы.Добавить(ПараметрыПоля);
	
	РаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ДобавляемыеЭлементы);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ФормаНастройкаЦеныИзменена" Или ИмяСобытия = "Запись_НаборКонстант" Тогда
		ИзменениеНастройкиЦеныПродажи();
	ИначеЕсли ИмяСобытия = "НазначенаПоКнопкеОсновнаяСпецификацияВСпискеСпецификаций" Тогда
		
		// Спецификация может быть назначена основной из списка спецификаций, открытого в подчиненной форме.
		// Информация об основной спецификации хранится в справочнике Номенклатура.
		// Однако, непосредственно из списка спецификаций менять элемент номенклатуры не следует,
		// так как это может привести к выдаче пользователю непонятного ему сообщения 
		// "Данные были изменены другим пользователем".
		// Поэтому список посылает оповещение форме номенклатуры, которая записывает сама себя.
		Если Параметр.Номенклатура = Объект.Ссылка Тогда
			УстановитьОсновнуюСпецификацию(Параметр.ОсновнаяСпецификация);
			ОповеститьОбИзменении(Параметр.ОсновнаяСпецификация);
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ЗаписанаСпецификацияНоменклатуры" Тогда
		
		Если Параметр.Свойство("НоменклатураПредыдущийВладелец") Тогда
			
			Если Параметр.НоменклатураВладелец = Объект.Ссылка Или Параметр.НоменклатураПредыдущийВладелец  = Объект.Ссылка Тогда
				
				Если Не Модифицированность Тогда 
					Прочитать();
				Иначе
					
					// Записать изменения уже нельзя.
					// Предотвратим возможность выполнить явно бесполезные действия,
					// но оставим возможность скопировать введенные данные в буфер обмена.
					
					Если Параметр.НоменклатураПредыдущийВладелец  = Объект.Ссылка Тогда
						Объект.ОсновнаяСпецификацияНоменклатуры = Неопределено;
					Иначе
						Объект.ОсновнаяСпецификацияНоменклатуры = Параметр.ИзмененнаяСпецификация;
					КонецЕсли;
					
					ОтобразитьОсновнуюСпецификацию();
					
				КонецЕсли;
				
			КонецЕсли;
				
		ИначеЕсли Параметр.НоменклатураВладелец = Объект.Ссылка Тогда
			
			// Вызывается, в двух случаях
			// 1. редактируем новую (первую) спецификацию - и записали ее
			// 2. изменили состав спецификации
			
			Если Не ЗначениеЗаполнено(Объект.ОсновнаяСпецификацияНоменклатуры) Тогда
				// записали новую
				УстановитьОсновнуюСпецификацию(Параметр.ИзмененнаяСпецификация);
				ОповеститьОбИзменении(Параметр.ИзмененнаяСпецификация);
			ИначеЕсли Объект.ОсновнаяСпецификацияНоменклатуры = Параметр.ИзмененнаяСпецификация Тогда
				// изменили состав существующей
				ОсновнаяСпецификацияПредставление = Параметр.СпецификацияПредставление;
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ИзменениеСчетаУчетаНоменклатуры" Тогда 
		ОтобразитьСчетУчета();
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПолучитьЗначениеЦен();
	ОтобразитьОсновнуюСпецификацию();

	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

// Процедура - обработчик события ПередЗаписьюНаСервере формы.
//
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Если элемент справочника ранее был записан и изменилась группа,
	// то необходимо очистить сохраненные значения для определения счета учета при поступлении.
	Если ЗначениеЗаполнено(Объект.Ссылка)
		И НЕ Объект.Родитель = Родитель Тогда
		ОбновитьПовторноИспользуемыеЗначения();		
	КонецЕсли;	                               	
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

// Процедура - обработчик события ПриЗаписиНаСервере формы.
//
&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ЗаписатьИзменениеЦеныВРегистр(ТекущийОбъект);	
КонецПроцедуры

// Процедура - обработчик события ПослеЗаписиНаСервере.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
КонецПроцедуры

// Процедура - обработчик события ПослеЗаписи.
//
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

// Процедура - обработчик события ПослеЗаписиНаСервере формы.
//
&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении Наименование.
//
&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	Объект.НаименованиеПолное = Объект.Наименование;	
КонецПроцедуры

&НаКлиенте
Процедура ОсновнаяСпецификацияПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	УдалосьЗаписатьОбъект = Истина;
	
	Если (Объект.Ссылка.Пустая() Или Модифицированность) Тогда
		УдалосьЗаписатьОбъект = Записать();
	КонецЕсли;
	
	Если УдалосьЗаписатьОбъект Тогда
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Владелец", Объект.Ссылка);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ",                          Объект.ОсновнаяСпецификацияНоменклатуры);
		ПараметрыФормы.Вставить("ОткрытоИзКарточкиНоменклатуры", Истина);
		ПараметрыФормы.Вставить("ЗначенияЗаполнения",            ЗначенияЗаполнения);
		
		ОткрытьФорму("Справочник.СпецификацииНоменклатуры.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УслугаПриИзменении(Элемент)
	
	Объект.КодГКЭД = Неопределено;
	Объект.КодТНВЭД = Неопределено;
	
	Объект.ЭтоМаркированнаяПродукция = Ложь;	
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ЦенаПродажиИзНоменклатурыПриИзменении(Элемент)
	ЦенаПродажиМодифицирована = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЦенаЗакупкиИзНоменклатурыПриИзменении(Элемент)
	ЦенаЗакупкиМодифицирована = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЦенаПлановаяИзНоменклатурыПриИзменении(Элемент)
	ЦенаПлановаяМодифицирована = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодсказкаЦеныПродажиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "e1cib/data/Обработка.ПанельАдминистрированияБП.Форма.ФормаНастройкиЦен" Тогда
		
		СтандартнаяОбработка = Ложь; // Форму будем открывать с параметром
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ОткрытаИзКарточкиНоменклатуры", Истина);
		
		ОткрытьФорму("Обработка.ПанельАдминистрированияБП.Форма.ФормаНастройкиЦен", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодсказкаЦеныЗакупкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "e1cib/data/Обработка.ПанельАдминистрированияБП.Форма.ФормаНастройкиЦен" Тогда
		
		СтандартнаяОбработка = Ложь; // Форму будем открывать с параметром
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ОткрытаИзКарточкиНоменклатуры", Истина);
		
		ОткрытьФорму("Обработка.ПанельАдминистрированияБП.Форма.ФормаНастройкиЦен", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодсказкаЦеныПлановойОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "e1cib/data/Обработка.ПанельАдминистрированияБП.Форма.ФормаНастройкиЦен" Тогда
		
		СтандартнаяОбработка = Ложь; // Форму будем открывать с параметром
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ОткрытаИзКарточкиНоменклатуры", Истина);
		
		ОткрытьФорму("Обработка.ПанельАдминистрированияБП.Форма.ФормаНастройкиЦен", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтобразитьСчетУчета()

	Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	
	СчетаУчетаНоменклатуры = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСчетаУчетаНоменклатуры(Организация, Объект.Ссылка);
	Если ЗначениеЗаполнено(СчетаУчетаНоменклатуры.СчетУчета) Тогда 
		СчетУчета = СчетаУчетаНоменклатуры.СчетУчета;
	Иначе 
		СчетУчета = НСтр("ru = 'не назначен'");	
	КонецЕсли;	
	
КонецПроцедуры // ОтобразитьСчетУчета()

&НаСервере
Процедура ОтобразитьОсновнуюСпецификацию()
	
	Если Не ЗначениеЗаполнено(Объект.ОсновнаяСпецификацияНоменклатуры) Тогда
		Элементы.ОсновнаяСпецификацияПредставление.Видимость = ПравоДоступа("Редактирование", Метаданные.Справочники.СпецификацииНоменклатуры);
		ОсновнаяСпецификацияПредставление = НСтр("ru = 'Заполнить'");
	Иначе
		ОсновнаяСпецификацияПредставление = УправлениеПроизводством.ПредставлениеОсновнойСпецификации(Объект.ОсновнаяСпецификацияНоменклатуры);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОсновнуюСпецификацию(ИзмененнаяСпецификация)
	
	Объект.ОсновнаяСпецификацияНоменклатуры = ИзмененнаяСпецификация;
	Если НЕ Модифицированность Тогда 
		Записать();
	КонецЕсли;	
	ОсновнаяСпецификацияПредставление = УправлениеПроизводством.ПредставлениеОсновнойСпецификации(ИзмененнаяСпецификация);
	
КонецПроцедуры

// Процедура устанавливает функциональные опции формы документа.
//
&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма, Организация, ТекущаяДатаСеанса());
КонецПроцедуры

&НаСервере
// Процедура устанавливает видимость и доступность элементов.
//
Процедура УстановитьВидимостьДоступностьЭлементов()
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ТНВЭДКод", "Видимость", НЕ Объект.Услуга);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ТНВЭДНаименование", "Видимость", НЕ Объект.Услуга);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГКЭДКод", "Видимость", Объект.Услуга);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГКЭДНаименование", "Видимость", Объект.Услуга);

	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЭтоМаркированнаяПродукция", "Видимость", НЕ Объект.Услуга);
КонецПроцедуры // УстановитьВидимостьДоступностьЭлементов()

&НаСервере
Процедура ИзменениеНастройкиЦеныПродажи()
	
	ПолучитьЗначениеЦен();
	НастроитьЭлементыУправленияЦенами();
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИзменениеЦеныВРегистр(ТекущийОбъект)
	
	ПравоНаИзменениеРегистраЦен = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ЦеныНоменклатурыДокументов); 	
	
	Если ПравоНаИзменениеРегистраЦен Тогда
		
		РедактироватьВКарточкеНоменклатуры = 
			(Константы.НастройкаЗаполненияЦены.Получить() = Перечисления.НастройкаЗаполненияЦены.Номенклатура);
			
		// Цена продажи.
		Если РедактироватьВКарточкеНоменклатуры И ЦенаПродажиМодифицирована Тогда
			
			МенеджерЗаписи 						= РегистрыСведений.ЦеныНоменклатурыДокументов.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Номенклатура 		= ТекущийОбъект.Ссылка;
			МенеджерЗаписи.СпособЗаполненияЦены = Перечисления.СпособыЗаполненияЦен.ПоПродажнымЦенам;
			МенеджерЗаписи.Валюта				= ВалютаЦеныПродажи;
			МенеджерЗаписи.Цена 				= ЦенаПродажи;
			МенеджерЗаписи.ЦенаВключаетНалоги	= Истина;
			
			МенеджерЗаписи.Записать();
			
		КонецЕсли;
		
		// Цена закупки.
		Если РедактироватьВКарточкеНоменклатуры И ЦенаЗакупкиМодифицирована Тогда
			
			МенеджерЗаписи 						= РегистрыСведений.ЦеныНоменклатурыДокументов.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Номенклатура 		= ТекущийОбъект.Ссылка;
			МенеджерЗаписи.СпособЗаполненияЦены = Перечисления.СпособыЗаполненияЦен.ПоЗакупочнымЦенам;
			МенеджерЗаписи.Валюта				= ВалютаЦеныЗакупки;
			МенеджерЗаписи.Цена 				= ЦенаЗакупки;
			МенеджерЗаписи.ЦенаВключаетНалоги	= Истина;
			
			МенеджерЗаписи.Записать();
			
		КонецЕсли;
		
		// Цена плановая.
		Если РедактироватьВКарточкеНоменклатуры И ЦенаПлановаяМодифицирована Тогда
			
			МенеджерЗаписи 						= РегистрыСведений.ЦеныНоменклатурыДокументов.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Номенклатура 		= ТекущийОбъект.Ссылка;
			МенеджерЗаписи.СпособЗаполненияЦены = Перечисления.СпособыЗаполненияЦен.ПоПлановымЦенам;
			МенеджерЗаписи.Валюта				= ВалютаЦеныПлановой;
			МенеджерЗаписи.Цена 				= ЦенаПлановая;
			МенеджерЗаписи.ЦенаВключаетНалоги	= Истина;
			
			МенеджерЗаписи.Записать();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьЗначениеЦен()
	
	Если Не ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.ЦеныНоменклатурыДокументов) Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();	

	ЦенаПродажи = 0;
	ЦенаЗакупки = 0;
	ЦенаПлановая = 0;
	ВалютаЦеныПродажи = ВалютаРегламентированногоУчета;
	ВалютаЦеныЗакупки = ВалютаРегламентированногоУчета;
	ВалютаЦеныПлановой = ВалютаРегламентированногоУчета;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Номенклатура", Объект.Ссылка);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЦеныНоменклатурыДокументов.СпособЗаполненияЦены КАК СпособЗаполненияЦены,
		|	ЦеныНоменклатурыДокументов.Цена КАК Цена,
		|	ЦеныНоменклатурыДокументов.Валюта КАК Валюта
		|ИЗ
		|	РегистрСведений.ЦеныНоменклатурыДокументов КАК ЦеныНоменклатурыДокументов
		|ГДЕ
		|	ЦеныНоменклатурыДокументов.Номенклатура = &Номенклатура";
		
	// В форме номенклатуры цену всегда показываем как она записана в регистре.

	ВыборкаДанных = Запрос.Выполнить().Выбрать();
	Пока ВыборкаДанных.Следующий() Цикл 
		Цена = ВыборкаДанных.Цена;
		
		ВалютаЦены = ВыборкаДанных.Валюта;
		
		Если ВыборкаДанных.СпособЗаполненияЦены = Перечисления.СпособыЗаполненияЦен.ПоПродажнымЦенам Тогда 
			ЦенаПродажи = Цена;	
			ВалютаЦеныПродажи = ВалютаЦены;
		ИначеЕсли ВыборкаДанных.СпособЗаполненияЦены = Перечисления.СпособыЗаполненияЦен.ПоЗакупочнымЦенам Тогда 	
			ЦенаЗакупки = Цена;	
			ВалютаЦеныЗакупки = ВалютаЦены;
		ИначеЕсли ВыборкаДанных.СпособЗаполненияЦены = Перечисления.СпособыЗаполненияЦен.ПоПлановымЦенам Тогда 	
			ЦенаПлановая = Цена;	
			ВалютаЦеныПлановой = ВалютаЦены;
		КонецЕсли;
			
	КонецЦикла;
	
	ЦенаПродажиМодифицирована = Ложь;	
	ЦенаЗакупкиМодифицирована = Ложь;	
	ЦенаПлановаяМодифицирована = Ложь;	
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыУправленияЦенами()
	
	ЧтениеЦен = ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.ЦеныНоменклатурыДокументов);
	
	Если Не ЧтениеЦен Тогда
		Элементы.ГруппаЦенаПродажи.Видимость = Ложь;
		Элементы.ГруппаЦенаЗакупки.Видимость = Ложь;
		Элементы.ГруппаЦенаПлановая.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	ИзменениеЦен = ПравоДоступа("Редактирование", Метаданные.РегистрыСведений.ЦеныНоменклатурыДокументов);
	
	Элементы.ГруппаЦенаПродажи.Видимость = Истина;
	Элементы.ГруппаЦенаЗакупки.Видимость = Истина;
	Элементы.ГруппаЦенаПлановая.Видимость = Истина;
	
	РедактироватьВКарточкеНоменклатуры = (Константы.НастройкаЗаполненияЦены.Получить() = Перечисления.НастройкаЗаполненияЦены.Номенклатура);
	
	Если ИзменениеЦен Тогда
		Элементы.ЦенаПродажиИзНоменклатуры.ТолькоПросмотр = Не РедактироватьВКарточкеНоменклатуры;
		Элементы.ЦенаЗакупкиИзНоменклатуры.ТолькоПросмотр = Не РедактироватьВКарточкеНоменклатуры;
		Элементы.ЦенаПлановаяИзНоменклатуры.ТолькоПросмотр = Не РедактироватьВКарточкеНоменклатуры;
	Иначе
		Элементы.ЦенаПродажиИзНоменклатуры.ТолькоПросмотр = Истина;
		Элементы.ЦенаЗакупкиИзНоменклатуры.ТолькоПросмотр = Истина;
		Элементы.ЦенаПлановаяИзНоменклатуры.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ИзменениеНастройки = ПравоДоступа("Редактирование", Метаданные.Константы.НастройкаЗаполненияЦены);
	
	// Установка подсказки цены продажи.
	ЭлементыСтроки = Новый Массив;
	
	Если РедактироватьВКарточкеНоменклатуры Тогда
		ЭлементыСтроки.Добавить(НСтр("ru = 'По умолчанию цена продажи устанавливается в карточке номенклатуры.'"));
	Иначе
		ЭлементыСтроки.Добавить(НСтр("ru = 'По умолчанию цена продажи устанавливается в документах продажи (счетах, актах, накладных).'"));
	КонецЕсли;
	
	Если ИзменениеНастройки Тогда
		ЭлементыСтроки.Добавить(Символы.ПС);
		ЭлементыСтроки.Добавить(НСтр("ru = 'Изменить настройку можно в форме - '"));
		ЭлементыСтроки.Добавить(Новый ФорматированнаяСтрока("Заполнение цен",,,,"e1cib/data/Обработка.ПанельАдминистрированияБП.Форма.ФормаНастройкиЦен"));
	КонецЕсли;
	
	ТекстПодсказкиДляЦены = Новый ФорматированнаяСтрока(ЭлементыСтроки);
	Элементы.ВалютаЦеныПродажи.РасширеннаяПодсказка.Заголовок = ТекстПодсказкиДляЦены;
	
	// Установка подсказки цены закупки.
	ЭлементыСтроки = Новый Массив;
	
	Если РедактироватьВКарточкеНоменклатуры Тогда
		ЭлементыСтроки.Добавить(НСтр("ru = 'По умолчанию цена закупки устанавливается в карточке номенклатуры.'"));
	Иначе
		ЭлементыСтроки.Добавить(НСтр("ru = 'По умолчанию цена закупки устанавливается в документах поступления (счетах, накладных, авансовых отчетах).'"));
	КонецЕсли;
	
	Если ИзменениеНастройки Тогда
		ЭлементыСтроки.Добавить(Символы.ПС);
		ЭлементыСтроки.Добавить(НСтр("ru = 'Изменить настройку можно в форме - '"));
		ЭлементыСтроки.Добавить(Новый ФорматированнаяСтрока("Заполнение цен",,,,"e1cib/data/Обработка.ПанельАдминистрированияБП.Форма.ФормаНастройкиЦен"));
	КонецЕсли;
	
	ТекстПодсказкиДляЦены = Новый ФорматированнаяСтрока(ЭлементыСтроки);
	Элементы.ВалютаЦеныЗакупки.РасширеннаяПодсказка.Заголовок = ТекстПодсказкиДляЦены;
	
	// Установка подсказки цены плановой.
	ЭлементыСтроки = Новый Массив;
	
	Если РедактироватьВКарточкеНоменклатуры Тогда
		ЭлементыСтроки.Добавить(НСтр("ru = 'По умолчанию плановая цена устанавливается в карточке номенклатуры.'"));
	Иначе
		ЭлементыСтроки.Добавить(НСтр("ru = 'По умолчанию плановая цена устанавливается в документах производства (отчетах производства за смену, заказах на производство).'"));
	КонецЕсли;
	
	Если ИзменениеНастройки Тогда
		ЭлементыСтроки.Добавить(Символы.ПС);
		ЭлементыСтроки.Добавить(НСтр("ru = 'Изменить настройку можно в форме - '"));
		ЭлементыСтроки.Добавить(Новый ФорматированнаяСтрока("Заполнение цен",,,,"e1cib/data/Обработка.ПанельАдминистрированияБП.Форма.ФормаНастройкиЦен"));
	КонецЕсли;
	
	ТекстПодсказкиДляЦены = Новый ФорматированнаяСтрока(ЭлементыСтроки);
	Элементы.ВалютаЦеныПлановой.РасширеннаяПодсказка.Заголовок = ТекстПодсказкиДляЦены;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры // Подключаемый_РедактироватьСоставСвойств()

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма, РеквизитФормыВЗначение("Объект"));
КонецПроцедуры // ОбновитьЭлементыДополнительныхРеквизитов()

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)
	
	РаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	РаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент,
				ПараметрыПеретаскивания, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	РаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент,
				ПараметрыПеретаскивания, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)

	РаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);

КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

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

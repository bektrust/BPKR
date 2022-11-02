
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
	
	Если Параметры.Ключ.Пустая() Тогда
		УстановитьНачальныеСвойстваСубконтоТаблицы();
	КонецЕсли;	

	НесколькоСкладовВПроизводстве = ПолучитьФункциональнуюОпцию("НесколькоСкладовВПроизводстве");
	
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);		
	
	УстановитьВидимостьДоступностьЭлементов();

	УстановитьУсловноеОформление();

	// КопированиеСтрокТабличныхЧастей
	КопированиеТабличнойЧастиСервер.ПриСозданииНаСервере(Элементы, "Продукция");
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
	
	// ПодключаемоеОборудование
	ИспользоватьПодключаемоеОборудование = ПодключаемоеОборудованиеБППовтИсп.ИспользоватьПодключаемоеОборудование();
	// Конец ПодключаемоеОборудование
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УстановитьНачальныеСвойстваСубконтоТаблицы();

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

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПодборНоменклатурыПроизведен" 
		И ТипЗнч(Параметр) = Тип("Структура")
		// Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор Тогда
		
		АдресЗапасовВХранилище = Параметр.АдресЗапасовВХранилище;
		ПолучитьПродукцияИзХранилища(АдресЗапасовВХранилище);
		ОбновитьПодвалФормы();
	
	Иначе
		ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	КонецЕсли;
	
	// КопированиеСтрокТабличныхЧастей
	Если ИмяСобытия = "БуферОбменаТабличнаяЧастьКопированиеСтрок" Тогда
		КопированиеТабличнойЧастиКлиент.ОбработкаОповещения(Элементы, "Продукция");
	КонецЕсли;
	// Конец КопированиеСтрокТабличныхЧастей
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование"
		И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" Тогда
			// Преобразуем предварительно к ожидаемому формату.
			Если Параметр[1] = Неопределено Тогда
				ТекШтрихкод = Параметр[0]; // Достаем штрихкод из основных данных
			Иначе
				ТекШтрихкод = Параметр[1][1]; // Достаем штрихкод из дополнительных данных
			КонецЕсли;
			
			ПоискПоШтрихкодуЗавершение(ТекШтрихкод, Новый Структура("ТекШтрихкод, ИмяТабличнойЧасти", ТекШтрихкод, "Продукция"));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ПодключаемоеОборудование
	Если ИспользоватьПодключаемоеОборудование Тогда 
		МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода");
	КонецЕсли;	
	// Конец ПодключаемоеОборудование
КонецПроцедуры

// Процедура - обработчик события ПриЗакрытии.
//
&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	// ПодключаемоеОборудование
	Если ИспользоватьПодключаемоеОборудование Тогда 
		МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	КонецЕсли;	
	// Конец ПодключаемоеОборудование
КонецПроцедуры

// Процедура - обработчик события ПослеЗаписиНаСервере.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)	
	
	УстановитьНачальныеСвойстваСубконтоТаблицы();
	
	// РаботаСФормами
	РаботаСФормамиСервер.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец РаботаСФормами
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчета.ПослеЗаписиНаСервере(ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
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
	
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоТаблицыПриИзмененииОрганизации(
		Объект.Услуги,
		ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
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

// Процедура - обработчик события ПриИзменении флага НоменклатурнаяГруппаВТаблице.
//
&НаКлиенте
Процедура НоменклатурнаяГруппаВТаблицеПриИзменении(Элемент)
	ЗаполнитьНоменклатурнуюГруппу();
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицФормы

#Область Продукция

// Процедура - обработчик события ПередНачаломДобавления таблицы Продукция.
//
&НаКлиенте
Процедура ПродукцияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Копирование Тогда 
		ИтогСумма = Объект.Продукция.Итог("СуммаПлановая") + Элемент.ТекущиеДанные.СуммаПлановая;
	КонецЕсли;	
КонецПроцедуры

// Процедура - обработчик события ПослеУдаления таблицы Продукция.
//
&НаКлиенте
Процедура ПродукцияПослеУдаления(Элемент)
	ОбновитьПодвалФормы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Номенклатура.
//
&НаКлиенте
Процедура ПродукцияНоменклатураПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Продукция.ТекущиеДанные;
	ОбработатьИзменениеНоменклатуры(СтрокаТабличнойЧасти);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Количество.
//
&НаКлиенте
Процедура ПродукцияКоличествоПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Продукция.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьПлановуюСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);	
	
	ОбновитьПодвалФормы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ПродукцияПлановаяСтоимость.
//
&НаКлиенте
Процедура ПродукцияПлановаяСтоимостьПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Продукция.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьПлановуюСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);	
	
	ОбновитьПодвалФормы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Сумма.
//
&НаКлиенте
Процедура ПродукцияСуммаПлановаяПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Продукция.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьПлановуюСтоимостьСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);	
	
	ОбновитьПодвалФормы();
КонецПроцедуры

#КонецОбласти

#Область Услуги

// Процедура - обработчик события ПередНачаломИзменения таблицы Товары.
//
&НаКлиенте
Процедура УслугиПередНачаломИзменения(Элемент, Отказ)
	ТекущиеДанные = Элементы.Услуги.ТекущиеДанные;
	
	БухгалтерскийУчетКлиентСервер.УстановитьНачальныеСвойстваСубконтоСтроки(
		ЭтотОбъект, ТекущиеДанные, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура УслугиНоменклатураПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("Дата", ДатаДокумента);
	СтруктураДанные.Вставить("Организация", Объект.Организация);
	СтруктураДанные.Вставить("Номенклатура", СтрокаТабличнойЧасти.Номенклатура);
	
	СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);

	// Заполнение по данным номенклатуры.
	СтрокаТабличнойЧасти.СчетЗатрат = СтруктураДанные.СчетРасходов;
	СтрокаТабличнойЧасти.Спецификация = СтруктураДанные.ОсновнаяСпецификацияНоменклатуры;
	
	// Изменен счет затарт.
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоСтрокиПриИзмененииСчета(
		ЭтотОбъект, СтрокаТабличнойЧасти, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура УслугиКоличествоПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьПлановуюСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);	
	
	ОбновитьПодвалФормы();
КонецПроцедуры

&НаКлиенте
Процедура УслугиПлановаяСтоимостьПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьПлановуюСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);	
	
	ОбновитьПодвалФормы();
КонецПроцедуры

&НаКлиенте
Процедура УслугиСуммаПлановаяПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьПлановуюСтоимостьСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);	
	
	ОбновитьПодвалФормы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода СчетРасходов.
//
&НаКлиенте
Процедура УслугиСчетЗатратПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Услуги.ТекущиеДанные;
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоСтрокиПриИзмененииСчета(
		ЭтотОбъект, ТекущиеДанные, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода УслугиСубконто1.
//
&НаКлиенте
Процедура УслугиСубконто1ПриИзменении(Элемент)
	ПриИзмененииСубконто(1);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода УслугиСубконто2.
//
&НаКлиенте
Процедура УслугиСубконто2ПриИзменении(Элемент)
	ПриИзмененииСубконто(2);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода УслугиСубконто3.
//
&НаКлиенте
Процедура УслугиСубконто3ПриИзменении(Элемент)
	ПриИзмененииСубконто(3);
КонецПроцедуры

#КонецОбласти

#Область ВозвратныеОтходы

&НаКлиенте
Процедура ВозвратныеОтходыНоменклатураПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.ВозвратныеОтходы.ТекущиеДанные;
	ОбработатьИзменениеНоменклатуры(СтрокаТабличнойЧасти);
КонецПроцедуры

&НаКлиенте
Процедура ВозвратныеОтходыКоличествоПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.ВозвратныеОтходы.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);	
КонецПроцедуры

&НаКлиенте
Процедура ВозвратныеОтходыЦенаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.ВозвратныеОтходы.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);	
КонецПроцедуры

&НаКлиенте
Процедура ВозвратныеОтходыСуммаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.ВозвратныеОтходы.ТекущиеДанные;
	
	ПараметрыРасчета = Новый Структура;
	ПараметрыРасчета.Вставить("ПризнакСтраныЕАЭС", 			Ложь);
	ПараметрыРасчета.Вставить("ПризнакСтраныИмпортЭкспорт", Ложь);
	ПараметрыРасчета.Вставить("СчитатьОтДохода", 			Ложь);
	ПараметрыРасчета.Вставить("Точность", 					2);
	
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьЦенуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти, ПараметрыРасчета);	
КонецПроцедуры

&НаКлиенте
Процедура ВозвратныеОтходыПродукцияПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.ВозвратныеОтходы.ТекущиеДанные;
	УстановитьНоменклатурнуюГруппуПродукции(СтрокаТабличнойЧасти.НоменклатурнаяГруппа, СтрокаТабличнойЧасти.Продукция);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик события действия команды Подбор в табличную часть Продукция.
// Открывает форму подбора.
//
&НаКлиенте
Процедура ПодборНоменклатуры(Команда)
	РаботаСПодборомНоменклатурыКлиент.ОткрытьПодбор(ЭтаФорма, "Продукция", "Поступление");
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьМатериалыЗаказчика(Команда)

	Если Объект.Материалы.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'Перед заполнением табличная часть будет очищена.
			|Заполнить?'") ;
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗаполнениемТабличнойЧастиЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
	Иначе
		ЗаполнитьМатериалыПоСпецификацииНаСервере();
	КонецЕсли;

КонецПроцедуры

// ПодключаемоеОборудование
&НаКлиенте
Процедура ПоискПоШтрихкодуПродукция(Команда)
	
	ТекШтрихкод = "";
	ПоказатьВводЗначения(Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", 
		ЭтотОбъект, Новый Структура("ТекШтрихкод, ИмяТабличнойЧасти", ТекШтрихкод, "Продукция")), ТекШтрихкод, НСтр("ru = 'Введите штрихкод'"));
		
КонецПроцедуры
	
&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ТекШтрихкод = ?(Результат = Неопределено, ДополнительныеПараметры.ТекШтрихкод, Результат);
    
	Если НЕ ПустаяСтрока(ТекШтрихкод) Тогда
        ПолученыШтрихкоды(Новый Структура("Штрихкод, Количество", ТекШтрихкод, 1), ДополнительныеПараметры.ИмяТабличнойЧасти);
	КонецЕсли;	

КонецПроцедуры 
// Конец ПодключаемоеОборудование

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ВопросПередЗаполнениемТабличнойЧастиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.Материалы.Очистить();
		ЗаполнитьМатериалыПоСпецификацииНаСервере();
	КонецЕсли;
	
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

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Если Объект.НоменклатурнаяГруппаВТаблице Тогда 
		Элементы.НоменклатурнаяГруппа.Видимость = Ложь;
		Элементы.ПродукцияНоменклатурнаяГруппа.Видимость = Истина;
		Элементы.УслугиНоменклатурнаяГруппа.Видимость = Истина;
		Элементы.ВозвратныеОтходыНоменклатурнаяГруппа.Видимость = Истина;
		Элементы.МатериалыНоменклатурнаяГруппа.Видимость = Истина;
	Иначе 
		Элементы.НоменклатурнаяГруппа.Видимость = Истина;
		Элементы.ПродукцияНоменклатурнаяГруппа.Видимость = Ложь;
		Элементы.УслугиНоменклатурнаяГруппа.Видимость = Ложь;
		Элементы.ВозвратныеОтходыНоменклатурнаяГруппа.Видимость = Ложь;
		Элементы.МатериалыНоменклатурнаяГруппа.Видимость = Ложь;
	КонецЕсли;	
	
	Элементы.Склад.Видимость = НЕ НесколькоСкладовВПроизводстве;
КонецПроцедуры 

// Процедура настройки условного оформления форм и динамических списков .
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// Таблица Услуги.
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("УслугиСубконто1");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Услуги.Субконто1Доступность");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("УслугиСубконто2");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Услуги.Субконто2Доступность");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("УслугиСубконто3");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Услуги.Субконто3Доступность");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

КонецПроцедуры

// Процедура - Установить пиктограмму комментария.
//
&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеНоменклатуры(СтрокаТабличнойЧасти)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("Дата", ДатаДокумента);
	СтруктураДанные.Вставить("Организация", Объект.Организация);
	СтруктураДанные.Вставить("Номенклатура", СтрокаТабличнойЧасти.Номенклатура);
	
	СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);

	// Заполнение по данным номенклатуры
	СтрокаТабличнойЧасти.СчетУчета = СтруктураДанные.СчетУчета;
	Если СтрокаТабличнойЧасти.Свойство("Спецификация") Тогда 
		СтрокаТабличнойЧасти.Спецификация = СтруктураДанные.ОсновнаяСпецификацияНоменклатуры;
	КонецЕсли;
	
	Если СтрокаТабличнойЧасти.Свойство("ПлановаяСтоимость") Тогда 
		СтрокаТабличнойЧасти.ПлановаяСтоимость = СтруктураДанные.Цена;
		// Расчет стоимости
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьПлановуюСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);	
	ИначеЕсли СтрокаТабличнойЧасти.Свойство("Цена") Тогда 
		СтрокаТабличнойЧасти.Цена = СтруктураДанные.Цена;
		// Расчет суммы
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);	
	КонецЕсли;	
	
КонецПроцедуры	

// Получает набор данных с сервера для процедуры НоменклатураПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные)
	
	// Счета учета
	СчетаУчетаНоменклатуры = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСчетаУчетаНоменклатуры(СтруктураДанные.Организация, СтруктураДанные.Номенклатура);
	СтруктураДанные.Вставить("СчетУчета", СчетаУчетаНоменклатуры.СчетУчета);
	СтруктураДанные.Вставить("СчетРасходов", СчетаУчетаНоменклатуры.СчетРасходов);
	СтруктураДанные.Вставить("ОсновнаяСпецификацияНоменклатуры", СтруктураДанные.Номенклатура.ОсновнаяСпецификацияНоменклатуры);
	
	// Цены
	Цена = 0;
	ТипЦен = Константы.ТипЦенПлановойСебестоимостиНоменклатуры.Получить();
	СтруктураДанные.Вставить("ВалютаДокумента", ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	Если ЗначениеЗаполнено(ТипЦен) Тогда 
		СтруктураДанные.Вставить("ТипЦен", ТипЦен);
		Цена = Ценообразование.ПолучитьЦенуНоменклатуры(СтруктураДанные);
	КонецЕсли;
	// Цены документов
	Если Цена = 0 Тогда
		СтруктураДанные.Вставить("СпособЗаполненияЦены", Перечисления.СпособыЗаполненияЦен.ПоПлановымЦенам);
		Цена = Ценообразование.ПолучитьЦенуПоДокументам(СтруктураДанные);
	КонецЕсли;	
	СтруктураДанные.Вставить("Цена", Цена);

	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеНоменклатураПриИзменении()

// Устанавливает номенклатурную группу, на которую потрачены материалы (при интерактивном вводе наименования продукции).
//
// Параметры:
//  НоменклатурнаяГруппа - СправочникСсылка.НоменклатурныеГруппы - возвращаемый параметр, в который будет помещена
//                                                                 номенклатурная группа
//  Продукция			 - СправочникСсылка.Номенклатура - изготавливаемая продукция, которая определяет номенклатурную группу
// 
&НаКлиенте
Процедура УстановитьНоменклатурнуюГруппуПродукции(НоменклатурнаяГруппа, Продукция)
	
	Если БухгалтерскийУчетВызовСервераПовтИсп.ИспользоватьОднуНоменклатурнуюГруппу() Тогда
		
		Если Не ЗначениеЗаполнено(НоменклатурнаяГруппа) Тогда
			НоменклатурнаяГруппа = БухгалтерскийУчетВызовСервераПовтИсп.ОсновнаяНоменклатурнаяГруппа();
		КонецЕсли;
		
	Иначе
		
		НоменклатурнаяГруппаПродукции = НоменклатурнаяГруппаПродукции(Продукция);
		Если ЗначениеЗаполнено(НоменклатурнаяГруппаПродукции) Тогда
			НоменклатурнаяГруппа = НоменклатурнаяГруппаПродукции;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Это серверная часть процедуры УстановитьНоменклатурнуюГруппуПродукции()
//
&НаСервереБезКонтекста
Функция НоменклатурнаяГруппаПродукции(Знач Продукция)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Продукция, "НоменклатурнаяГруппа", Истина);
		
КонецФункции

// Процедура заполняет номенклатурную группу значением из шапки и наоборот
//
&НаКлиенте
Процедура ЗаполнитьНоменклатурнуюГруппу()
	Если Объект.НоменклатурнаяГруппаВТаблице Тогда 
		Для Каждого СтрокаТабличнойЧасти Из Объект.Продукция Цикл 
			СтрокаТабличнойЧасти.НоменклатурнаяГруппа = Объект.НоменклатурнаяГруппа;
		КонецЦикла;	
		Для Каждого СтрокаТабличнойЧасти Из Объект.Услуги Цикл 
			СтрокаТабличнойЧасти.НоменклатурнаяГруппа = Объект.НоменклатурнаяГруппа;
		КонецЦикла;	
		Для Каждого СтрокаТабличнойЧасти Из Объект.ВозвратныеОтходы Цикл 
			СтрокаТабличнойЧасти.НоменклатурнаяГруппа = Объект.НоменклатурнаяГруппа;
		КонецЦикла;	
		Для Каждого СтрокаТабличнойЧасти Из Объект.Материалы Цикл 
			СтрокаТабличнойЧасти.НоменклатурнаяГруппа = Объект.НоменклатурнаяГруппа;
		КонецЦикла;	
		
		Объект.НоменклатурнаяГруппа = ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.ПустаяСсылка");
	Иначе 
		Если Объект.Продукция.Количество() > 0 Тогда
			Объект.НоменклатурнаяГруппа = Объект.Продукция[0].НоменклатурнаяГруппа;
		КонецЕсли;	
			
		Для Каждого СтрокаТабличнойЧасти Из Объект.Материалы Цикл 
			СтрокаТабличнойЧасти.НоменклатурнаяГруппа = ПредопределенноеЗначение("Справочник.НоменклатурныеГруппы.ПустаяСсылка");
		КонецЦикла;
	КонецЕсли;	
КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьМатериалыПоСпецификацииНаСервере()
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗаполнитьМатериалыПоПродукцииУслугам();
	ЗначениеВРеквизитФормы(Документ, "Объект");
	
	// Заполнение счета учета.	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("Дата", ДатаДокумента);
	СтруктураДанные.Вставить("Организация", Объект.Организация);

	Для Каждого СтрокаТабличнойЧасти Из Объект.Материалы Цикл 
		СтруктураДанные.Вставить("Номенклатура", СтрокаТабличнойЧасти.Номенклатура);
		СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);

		// Заполнение по данным номенклатуры
		СтрокаТабличнойЧасти.СчетУчета = СтруктураДанные.СчетУчета;
	КонецЦикла;
	
	Модифицированность = Истина;

КонецПроцедуры

// Процедура рассчитывает итоги для подвала формы.
//
&НаКлиенте
Процедура ОбновитьПодвалФормы()
	
	ИтогСумма = Объект.Продукция.Итог("СуммаПлановая") + Объект.Услуги.Итог("СуммаПлановая");
	
КонецПроцедуры // ОбновитьПодвалФормы()

// Процедура - обработчик подбора.
//
&НаСервере
Процедура ПолучитьПродукцияИзХранилища(АдресЗапасовВХранилище)
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресЗапасовВХранилище);
	
	Для Каждого СтрокаЗагрузки Из ТаблицаДляЗагрузки Цикл
		НайденныеСтроки = Объект.Продукция.НайтиСтроки(Новый Структура("Номенклатура", СтрокаЗагрузки.Номенклатура));
		
		Если НайденныеСтроки.Количество() > 0 Тогда 
			Продолжить;
		КонецЕсли;	
		
		СтрокаТабличнойЧасти = Объект.Продукция.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаЗагрузки);
		СтрокаТабличнойЧасти.ПлановаяСтоимость = СтрокаЗагрузки.Цена;
		
		СтруктураДанные = Новый Структура();
		СтруктураДанные.Вставить("Дата", ДатаДокумента);
		СтруктураДанные.Вставить("Организация", Объект.Организация);
		СтруктураДанные.Вставить("Номенклатура", СтрокаТабличнойЧасти.Номенклатура);
		
		СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);

		// Заполнение по данным номенклатуры
		СтрокаТабличнойЧасти.СчетУчета = СтруктураДанные.СчетУчета;
		Если СтрокаТабличнойЧасти.Свойство("Спецификация") Тогда 
			СтрокаТабличнойЧасти.Спецификация = СтруктураДанные.ОсновнаяСпецификацияНоменклатуры;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ПлановаяСтоимость) Тогда 			
			СтрокаТабличнойЧасти.ПлановаяСтоимость = СтруктураДанные.Цена;
		КонецЕсли;	
		
		// Расчет стоимости
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьПлановуюСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);	
	КонецЦикла;
КонецПроцедуры // ПолучитьЗапасыИзХранилища()

// ПодключаемоеОборудование

// Процедура - Получены штрихкоды
//
// Параметры:
//  ДанныеШтрихкодов	 - Структура/Массив - В зависимости от точки вызова передается структура (обработка сканера) или массив (обработка ТСД)
//  ИмяТабличнойЧасти	 - Строка	 - Имя табличной части для загрузки
//
&НаКлиенте
Процедура ПолученыШтрихкоды(ДанныеШтрихкодов, ИмяТабличнойЧасти) Экспорт
	
	Модифицированность = Истина;
	
	НеДобавленныеШтрихкоды = ЗаполнитьПоДаннымШтрихкодов(ДанныеШтрихкодов, ИмяТабличнойЧасти);
	
	// Неизвестные штрихкоды.
	Если НеДобавленныеШтрихкоды.НеизвестныеШтрихкоды.Количество() > 0 Тогда
		Для Каждого СтруктураДанные Из НеДобавленныеШтрихкоды.НеизвестныеШтрихкоды Цикл 
			СтрокаСообщения = СтрШаблон(НСтр("ru = 'Данные по штрихкоду не найдены: %1'"), СтруктураДанные.Штрихкод);
			ОбщегоНазначенияКлиент.СообщитьПользователю(СтрокаСообщения);
		КонецЦикла;	
	// Штрихкоды некорректного типа.
	ИначеЕсли НеДобавленныеШтрихкоды.ШтрихкодыНекорректногоТипа.Количество() > 0 Тогда 
		Для Каждого СтруктураДанные Из НеДобавленныеШтрихкоды.ШтрихкодыНекорректногоТипа Цикл 
			СтрокаСообщения = СтрШаблон(НСтр("ru = 'Найденная по штрихкоду %1 номенклатура: ""%2"", не подходит для этой табличной части'"),
				СтруктураДанные.ТекШтрихкод, СтруктураДанные.Номенклатура);
			ОбщегоНазначенияКлиент.СообщитьПользователю(СтрокаСообщения);
		КонецЦикла;	
	КонецЕсли;	
	
КонецПроцедуры // ПолученыШтрихкоды()

&НаСервереБезКонтекста
Функция ПолучитьДанныеПоШтрихкоду(ТекШтрихкод)
	
	Номенклатура = РегистрыСведений.ШтрихкодыНоменклатуры.ПолучитьНоменклатуруПоШтрихкоду(ТекШтрихкод);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("Номенклатура", Номенклатура);
	СтруктураДанные.Вставить("ТипНоменклатурыУслуга", ?(ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура"), Номенклатура.Услуга, Ложь));
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеПоШтрихкоду()

// Функция - Заполнить по данным штрихкодов
//
// Параметры:
//  ДанныеШтрихкодов		 - 	 - Структура/Массив	 - В зависимости от точки вызова передается структура (обработка сканера) или массив (обработка ТСД)
//  ИмяТабличнойЧасти	 - Строка	 - Имя табличной части для загрузки
// 
// Возвращаемое значение:
//  Структура - Массивы неизвестных штрих кодов
//
&НаКлиенте
Функция ЗаполнитьПоДаннымШтрихкодов(ДанныеШтрихкодов, ИмяТабличнойЧасти) 
	
	НеизвестныеШтрихкоды = Новый Массив;
	ШтрихкодыНекорректногоТипа = Новый Массив;
	
	Если ТипЗнч(ДанныеШтрихкодов) = Тип("Массив") Тогда
		МассивШтрихкодов = ДанныеШтрихкодов;
	Иначе
		МассивШтрихкодов = Новый Массив;
		МассивШтрихкодов.Добавить(ДанныеШтрихкодов);
	КонецЕсли;
	
	Для каждого ТекШтрихкод Из МассивШтрихкодов Цикл
		СтруктураДанные = ПолучитьДанныеПоШтрихкоду(ТекШтрихкод);
		
		Если НЕ ЗначениеЗаполнено(СтруктураДанные.Номенклатура) Тогда 
			НеизвестныеШтрихкоды.Добавить(ТекШтрихкод);
		ИначеЕсли СтруктураДанные.ТипНоменклатурыУслуга Тогда
			ШтрихкодыНекорректногоТипа.Добавить(Новый Структура("ТекШтрихкод, Номенклатура", ТекШтрихкод, СтруктураДанные.Номенклатура));
		Иначе 
			СтрокаТабличнойЧасти = Объект[ИмяТабличнойЧасти].Добавить();
			СтрокаТабличнойЧасти.Номенклатура = СтруктураДанные.Номенклатура;
			СтрокаТабличнойЧасти.Количество = ТекШтрихкод.Количество;
			
			ОбработатьИзменениеНоменклатуры(СтрокаТабличнойЧасти);
		КонецЕсли;
	КонецЦикла;	
	
	Возврат Новый Структура("НеизвестныеШтрихкоды, ШтрихкодыНекорректногоТипа",
		НеизвестныеШтрихкоды, ШтрихкодыНекорректногоТипа);

КонецФункции // ЗаполнитьПоДаннымШтрихкодов()
// Конец ПодключаемоеОборудование

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииРаботаССубконто

&НаСервере
Процедура УстановитьНачальныеСвойстваСубконтоТаблицы()
	БухгалтерскийУчетКлиентСервер.УстановитьНачальныеСвойстваСубконтоТаблицы(
		Объект.Услуги,
		ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыУстановкиСвойствСубконто(Форма)

	Результат = БухгалтерскийУчетКлиентСервер.ПараметрыУстановкиСвойствСубконтоПоШаблону(
		"УслугиСубконто", "Субконто", "СчетЗатрат");
	
	Результат.ДопРеквизиты.Вставить("Организация", Форма.Объект.Организация);
	Результат.СкрыватьСубконто = Ложь;
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура ПриИзмененииСубконто(НомерСубконто)
	
	СтрокаТаблицы = Элементы.Услуги.ТекущиеДанные;
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоСтрокиПриИзмененииСубконто(
		ЭтотОбъект, 
		СтрокаТаблицы,
		НомерСубконто, 
		ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#Область КопированиеСтрокТабличныхЧастей

&НаКлиенте
Процедура ПродукцияКопироватьСтроки(Команда)
	
	КопироватьСтроки("Продукция");
	
КонецПроцедуры

&НаКлиенте
Процедура ПродукцияВставитьСтроки(Команда)
	
	ВставитьСтроки("Продукция");
	
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


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
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ДатаНачала", "МесяцСтрокойНачало");
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ДатаОкончания", "МесяцСтрокойОкончание");
	
	ПросроченныеДанныеЦвет = ЦветаСтиля.ПросроченныеДанныеЦвет;
	ПоясняющийТекст = ЦветаСтиля.ПоясняющийТекст;
	
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
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ДатаНачала", "МесяцСтрокойНачало");
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ДатаОкончания", "МесяцСтрокойОкончание");

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
	ЗаполнитьИнформационныйТекстРучногоРедактирования();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
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

// Процедура - обработчик события ПриИзменении поля ввода Сумма.
//
&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	ЗаполнитьИнформационныйТекстРучногоРедактирования();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Удержания.
//
&НаКлиенте
Процедура УдержанияПриИзменении(Элемент)
	ЗаполнитьИнформационныйТекстРучногоРедактирования();
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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУдержания

// Процедура - обработчик события ПриИзменении поля ввода УдержанияРазмер.
//
&НаКлиенте
Процедура УдержанияРазмерПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Удержания.ТекущиеДанные;
	СтрокаТабличнойЧасти.РучнаяКорректировка = Истина;
	
	// перераспределение суммы
	КоэффициентыРаспределения = Новый Массив;
	
	СуммаДляРаспределения = Объект.Сумма;
	Для Каждого СтрокаТабличнойЧасти Из Объект.Удержания Цикл 
		Если СтрокаТабличнойЧасти.РучнаяКорректировка Тогда 
			СуммаДляРаспределения = СуммаДляРаспределения - СтрокаТабличнойЧасти.Размер;
			Продолжить;
		КонецЕсли;	
		
		КоэффициентыРаспределения.Добавить(1);
	КонецЦикла;	
	
	МассивРаспределенныхСумм = ОбщегоНазначенияКлиентСервер.РаспределитьСуммуПропорциональноКоэффициентам(СуммаДляРаспределения, КоэффициентыРаспределения);
	Если МассивРаспределенныхСумм = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	// заполнение табличной части
	Индекс = 0;
	Для Каждого СтрокаТабличнойЧасти Из Объект.Удержания Цикл 
		Если СтрокаТабличнойЧасти.РучнаяКорректировка Тогда 
			Продолжить;
		КонецЕсли;	
		СтрокаТабличнойЧасти.Размер = МассивРаспределенныхСумм[Индекс];
		Индекс = Индекс + 1;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Асинх Процедура Заполнить(Команда)
	
	Отказ = Ложь;	
	Ошибки = Неопределено;

	Если НЕ ЗначениеЗаполнено(Объект.ФизЛицо) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнено поле ""Сотрудник"". Заполнение документа отменено.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,	"Объект.ФизЛицо", ТекстСообщения, Неопределено);
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.ВидРасчета) Тогда 
		ТекстСообщения = НСтр("ru = 'Не заполнено поле ""Вид удержания"". Заполнение документа отменено.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,	"Объект.ВидРасчета", ТекстСообщения, Неопределено);
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаНачала) Тогда 
		ТекстСообщения = НСтр("ru = 'Не заполнено поле ""Дата начала"". Заполнение документа отменено.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,	"Объект.ДатаНачала", ТекстСообщения, Неопределено);
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаОкончания) Тогда 
		ТекстСообщения = НСтр("ru = 'Не заполнено поле ""Дата окончания"". Заполнение документа отменено.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,	"Объект.ДатаОкончания", ТекстСообщения, Неопределено);
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(Объект.Сумма) Тогда 
		ТекстСообщения = НСтр("ru = 'Не заполнено поле ""Сумма"". Заполнение документа отменено.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,	"Объект.Сумма", ТекстСообщения, Неопределено);
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Объект.ДатаНачала) 
		И ЗначениеЗаполнено(Объект.ДатаОкончания)
		И Объект.ДатаНачала > Объект.ДатаОкончания Тогда 
		
		ТекстСообщения = НСтр("ru = 'Не верно указан период. Заполнение документа отменено.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,	"Объект.ДатаНачала", ТекстСообщения, Неопределено);
	КонецЕсли;	
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если Отказ Тогда 
		Возврат
	КонецЕсли;	
	
	Если Объект.Удержания.Количество() > 0 Тогда 
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет очищена. Продолжить выполнение операции?'");
		Ответ = Ждать ВопросАсинх(ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60); 
		
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;	

		Объект.Удержания.Очистить();	
	КонецЕсли;
	
	ЗаполнитьТабличнуюЧастьНаКлиенте();
	
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

&НаКлиенте
Процедура ЗаполнитьТабличнуюЧастьНаКлиенте()
	
	КоэффициентыРаспределения = Новый Массив;
	
	ДатаНачала = Объект.ДатаНачала;
	Пока НачалоМесяца(ДатаНачала) <= НачалоМесяца(Объект.ДатаОкончания) Цикл 
		КоэффициентыРаспределения.Добавить(1);
		ДатаНачала = ДобавитьМесяц(ДатаНачала, 1);
	КонецЦикла;	
	
	МассивРаспределенныхСумм = ОбщегоНазначенияКлиентСервер.РаспределитьСуммуПропорциональноКоэффициентам(Объект.Сумма, КоэффициентыРаспределения);
	
	// заполнение табличной части
	КоличествоМесяцев = 0;
	Для Каждого ЭлементМассива Из МассивРаспределенныхСумм Цикл 
		СтрокаТабличнойЧасти = Объект.Удержания.Добавить();
		СтрокаТабличнойЧасти.ПериодРегистрации = ДобавитьМесяц(НачалоМесяца(Объект.ДатаНачала), КоличествоМесяцев);
		СтрокаТабличнойЧасти.Размер = ЭлементМассива;
		
		КоличествоМесяцев = КоличествоМесяцев + 1;
	КонецЦикла;	
	
	РучнаяКорректировка = Ложь;
	ЗаполнитьИнформационныйТекстРучногоРедактирования();
КонецПроцедуры // ЗаполнитьТабличнуюЧастьНаСервере()

// Процедура определяет внесение ручных корректировок
//
&НаКлиенте
Процедура ОпределениеРучнойКорректировки()
	РучнаяКорректировка = Ложь;
	Для Каждого СтрокаТабличнойЧасти Из Объект.Удержания Цикл 
		Если СтрокаТабличнойЧасти.РучнаяКорректировка Тогда 
			РучнаяКорректировка = Истина;
			Прервать;
		КонецЕсли;	 		
	КонецЦикла;
КонецПроцедуры // ОпределениеРучнойКорректировки()

&НаКлиенте
Процедура ЗаполнитьИнформационныйТекстРучногоРедактирования()
	ОпределениеРучнойКорректировки();
	
	ИнформационныйТекст = "";
	ИнформационнаяКартинка = Новый Картинка;
	ЦветТекста = ПросроченныеДанныеЦвет;
	
	Если НЕ Объект.Удержания.Итог("Размер") = Объект.Сумма Тогда 
		ИнформационнаяКартинка = БиблиотекаКартинок.Предупреждение;
		ИнформационныйТекст = НСтр("ru = 'Сумма распределена не верно. Нажмите «Заполнить» чтобы вернуться к автоматическому заполнению.'");
	ИначеЕсли РучнаяКорректировка Тогда 	
		ИнформационнаяКартинка = БиблиотекаКартинок.Информация;
		ИнформационныйТекст = НСтр("ru = 'Сумма распределена с учетом ручных корректировок. Нажмите «Заполнить» чтобы вернуться к автоматическому заполнению.'");
	Иначе 	
		ИнформационныйТекст = НСтр("ru = 'Сумма распределена прямо пропорционально. При необходимости внесите изменения вручную.'");
		ИнформационнаяКартинка = БиблиотекаКартинок.Информация;
		ЦветТекста = ПоясняющийТекст;
	КонецЕсли;	
		
	РучноеРедактированиеИнформационныйТекст = ИнформационныйТекст;
	Элементы.РучноеРедактированиеИнформационныйТекст.ЦветТекста = ЦветТекста;
	Элементы.РучноеРедактированиеДекорация.Картинка = ИнформационнаяКартинка;	
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

#Область РедактированиеМесяцаСтрокой

&НаКлиенте
Процедура ДатаНачалаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ДатаНачала", "МесяцСтрокойНачало");
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ДатаНачала.
//
&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ДатаНачала", "МесяцСтрокойНачало", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ДатаНачала", "МесяцСтрокойНачало", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ДатаОкончания", "МесяцСтрокойОкончание");
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ДатаОкончания.
//
&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ДатаОкончания", "МесяцСтрокойОкончание", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ДатаОкончания", "МесяцСтрокойОкончание", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти


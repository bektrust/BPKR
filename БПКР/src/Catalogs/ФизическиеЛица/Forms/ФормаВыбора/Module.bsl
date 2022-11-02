
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	УстановитьСписокПодобранныхСотрудников();
	
	// Проинициализируем форму для отбора
	Параметры.Отбор.Свойство("Организация", Организация);
	Параметры.Отбор.Свойство("Подразделение", Подразделение);
	
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда 
		Параметры.Отбор.Свойство("ТекущаяОрганизация", Организация);
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(Подразделение) Тогда 
		Параметры.Отбор.Свойство("ТекущееПодразделение", Подразделение);
	КонецЕсли;	
	
	// Если это выбор из особенного документа, например "Прием на работу"
	// управляем отборами в зависимости от "принятости на работу"
	Если Параметры.Свойство("ТолькоНепринятые") Тогда 
		ТолькоНепринятые = Параметры.ТолькоНепринятые;
		//ТолькоНепринятые = Ложь;
	ИначеЕсли Параметры.Свойство("ДоступныНепринятые") Тогда 
		ДоступныНепринятые = Параметры.ДоступныНепринятые;
	Иначе 
		ДоступныНепринятые = Организация.Пустая() И Параметры.Отбор.Свойство("Организация");
	КонецЕсли;
	
	ПараметрыПолученияСотрудниковОрганизаций = Новый Структура("Организация, Подразделение");
	ПараметрыПолученияСотрудниковОрганизаций.Вставить("Организация", Организация);
	ПараметрыПолученияСотрудниковОрганизаций.Вставить("Подразделение", Подразделение);
	ПараметрыПолученияСотрудниковОрганизаций.Вставить("НачалоПериода", '00010101');
	ПараметрыПолученияСотрудниковОрганизаций.Вставить("КонецПериода", '00010101');
	ПараметрыПолученияСотрудниковОрганизаций.Вставить("Использовать", Истина);
	ПараметрыПолученияСотрудниковОрганизаций.Вставить("ДоступныНепринятые", ДоступныНепринятые); // Все
	ПараметрыПолученияСотрудниковОрганизаций.Вставить("ТолькоНепринятые", ТолькоНепринятые);
	
	Если ДоступныНепринятые Тогда
		ОтключатьОтборПоПериодуИлиОрганизации = Ложь;
		Параметры.Свойство("ТекущаяСтрока", ТекущееЗначение);		
		Параметры.Отбор.Очистить();
		Возврат;
	Иначе
		// Проинициализируем переменные, для отбора по периоду
		ОтборПоПериодуКадровыхДанных = Ложь;
			
		// Получим параметры периода отбора
		Если Параметры.Отбор.Свойство("НачалоПериодаПримененияОтбора") 
			И ЗначениеЗаполнено(Параметры.Отбор.НачалоПериодаПримененияОтбора) Тогда
			
			// Подбор работающих в указанном периоде, если окончание периода не задано,
			// считается, что отбираются работающие в текущем месяце
			ОтборПоПериодуКадровыхДанных = Истина;
			НачалоПериодаПримененияОтбора = Параметры.Отбор.НачалоПериодаПримененияОтбора;
				
			Если Параметры.Отбор.Свойство("ОкончаниеПериодаПримененияОтбора") 
				И ЗначениеЗаполнено(Параметры.Отбор.ОкончаниеПериодаПримененияОтбора) Тогда
				ОкончаниеПериодаПримененияОтбора = Параметры.Отбор.ОкончаниеПериодаПримененияОтбора;
			Иначе
				ОкончаниеПериодаПримененияОтбора = КонецМесяца(НачалоПериодаПримененияОтбора);
			КонецЕсли;
			
			Параметры.Отбор.Удалить("НачалоПериодаПримененияОтбора");
			Параметры.Отбор.Удалить("ОкончаниеПериодаПримененияОтбора");
		КонецЕсли;
			
		Если НЕ ОтборПоПериодуКадровыхДанных 
			И Параметры.Отбор.Свойство("МесяцПримененияОтбора") 
			И ЗначениеЗаполнено(Параметры.Отбор.МесяцПримененияОтбора) Тогда
			
			// Подбор работавших в указанном месяце
			ОтборПоПериодуКадровыхДанных = Истина;
					
			НачалоПериодаПримененияОтбора = Параметры.Отбор.МесяцПримененияОтбора;
			ОкончаниеПериодаПримененияОтбора = КонецМесяца(НачалоПериодаПримененияОтбора);
				
			Параметры.Отбор.Удалить("МесяцПримененияОтбора");
		КонецЕсли;
			
		Если НЕ ОтборПоПериодуКадровыхДанных 
			И Параметры.Отбор.Свойство("ДатаПримененияОтбора") 
			И ЗначениеЗаполнено(Параметры.Отбор.ДатаПримененияОтбора) Тогда
					
			// Подбор работающих на указанную дату
			ОтборПоПериодуКадровыхДанных = Истина;
					
			НачалоПериодаПримененияОтбора = Параметры.Отбор.ДатаПримененияОтбора;
			ОкончаниеПериодаПримененияОтбора = Параметры.Отбор.ДатаПримененияОтбора;
			
			Параметры.Отбор.Удалить("ДатаПримененияОтбора");
		КонецЕсли;
			
		ОтключатьОтборПоПериодуИлиОрганизации = Истина;
		ТекстНадписиИнформацииОбОтбореПоПериодуИлиОрганизации = "";
		
		// Если получены организация и сам период, сформируем список ссылок и установим отбор
		Если ЗначениеЗаполнено(Организация) И ОтборПоПериодуКадровыхДанных Тогда
			ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода 	= НачалоПериодаПримененияОтбора;
			ПараметрыПолученияСотрудниковОрганизаций.КонецПериода 	= ОкончаниеПериодаПримененияОтбора;
				
			ТекстНадписиИнформацииОбОтбореПоПериодуИлиОрганизации = НСтр("ru = 'В списке отображены сотрудники'");
			Если НачалоПериодаПримененияОтбора = ОкончаниеПериодаПримененияОтбора Тогда
					
				ТекстНадписиИнформацииОбОтбореПоПериодуИлиОрганизации = ТекстНадписиИнформацииОбОтбореПоПериодуИлиОрганизации + СтрШаблон(
					", " + НСтр("ru = 'работающие %1'"), 
					Формат(НачалоПериодаПримененияОтбора, "ДФ='дд ММММ гггг ""г.""'"));
						
			ИначеЕсли НачалоПериодаПримененияОтбора = НачалоМесяца(НачалоПериодаПримененияОтбора) 
					И ОкончаниеПериодаПримененияОтбора = НачалоДня(КонецМесяца(ОкончаниеПериодаПримененияОтбора)) 
					И Месяц(НачалоПериодаПримененияОтбора) = Месяц(ОкончаниеПериодаПримененияОтбора) Тогда
						
				ТекстНадписиИнформацииОбОтбореПоПериодуИлиОрганизации = ТекстНадписиИнформацииОбОтбореПоПериодуИлиОрганизации + СтрШаблон(
					", " + НСтр("ru = 'работающие в период - %1 г.'"), 
					Формат(НачалоПериодаПримененияОтбора, "ДФ='ММММ гггг'"));
						
			Иначе
						
				ТекстНадписиИнформацииОбОтбореПоПериодуИлиОрганизации = ТекстНадписиИнформацииОбОтбореПоПериодуИлиОрганизации + СтрШаблон(
					", " + НСтр("ru = 'работающие в период с %1 г. по %2 г.'"), 
					Формат(НачалоПериодаПримененияОтбора, "ДФ='дд ММММ гггг'"), 
					Формат(ОкончаниеПериодаПримененияОтбора, "ДФ='дд ММММ гггг'"));
			КонецЕсли;
		КонецЕсли; 
	КонецЕсли;
	
	МассивФизЛиц = ЭлементОтбораФизЛица(ПараметрыПолученияСотрудниковОрганизаций);
	Если ПараметрыПолученияСотрудниковОрганизаций.ТолькоНепринятые Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", МассивФизЛиц, ВидСравненияКомпоновкиДанных.НеВСписке);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", МассивФизЛиц, ВидСравненияКомпоновкиДанных.ВСписке);
	КонецЕсли;
	
	ОтключитьОтборПоПериодуИлиОрганизации = Истина;
	
	ЭлементыОтбора = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(Список.Отбор, "Ссылка");
	Для каждого ЭлементОтбора Из ЭлементыОтбора Цикл
		ЭлементОтбора.Использование = НЕ ОтключитьОтборПоПериодуИлиОрганизации;
	КонецЦикла;
	
	Если ОтключатьОтборПоПериодуИлиОрганизации Тогда
			
		ТекстНадписиИнформацииОбОтбореПоПериодуИлиОрганизации = ТекстНадписиИнформацииОбОтбореПоПериодуИлиОрганизации
			+ " " + НСтр("ru = 'Чтобы увидеть полный список сотрудников установите флажок ""Показать всех"".'");
							
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"НадписьИнформацияОбОтбореПоПериодуИлиОрганизации",
			"Заголовок",
			ТекстНадписиИнформацииОбОтбореПоПериодуИлиОрганизации);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ГруппаИнфоНадписиОтбораПоПериодуИлиОрганизации",
			"Видимость",
			Истина);
	КонецЕсли; 
			
	Если Параметры.МножественныйВыбор = Истина Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"Список",
			"МножественныйВыбор",
			Истина);
			
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
			
		АдресСпискаПодобранныхСотрудников = "";
		Если Параметры.Свойство("АдресСпискаПодобранныхСотрудников", АдресСпискаПодобранныхСотрудников) Тогда
			Если НЕ ПустаяСтрока(АдресСпискаПодобранныхСотрудников) Тогда
				СписокПодобранных.ЗагрузитьЗначения(ПолучитьИзВременногоХранилища(АдресСпискаПодобранныхСотрудников));
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;
	
	УстановитьСписокПодобранныхСотрудников();
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода Подразделение.
//
&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	ПараметрыПолученияСотрудниковОрганизаций.Подразделение = Подразделение;
	МассивФизЛиц = ЭлементОтбораФизЛица(ПараметрыПолученияСотрудниковОрганизаций);
	Если ПараметрыПолученияСотрудниковОрганизаций.ТолькоНепринятые Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", МассивФизЛиц, ВидСравненияКомпоновкиДанных.НеВСписке);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", МассивФизЛиц, ВидСравненияКомпоновкиДанных.ВСписке);
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Подразделение",	"ТолькоПросмотр", ЗначениеЗаполнено(Подразделение));
КонецПроцедуры // УстановитьВидимостьДоступностьЭлементов()

// Процедура настройки условного оформления форм и динамических списков .
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// Таблица СписокОС.
	Элемент = УсловноеОформление.Элементы.Добавить();
	// Поля.	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, "Список");
	// Условие.	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор, "Список.Подобран", ВидСравненияКомпоновкиДанных.Равно, Истина);
	// Оформление.
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЦвет);
	
КонецПроцедуры

// Устанавливает отбор в динамическом списке
//
// Параметры:
//  Список  						- ДинамическийСписок - список, в котором устанавливается отбор
//  ПараметрыПолученияСотрудников 	- Структура - структура для отбора с полями 
// 										НачалоПериода  	- Дата - период для отбора
// 										КонецПериода  	- Дата - период для отбора
// 										Организация  	- СправочникСсылка.Организации - организация для отбора
//  									Подразделение  	- СправочникСсылка.ПодразделенияОрганизаций - подразделение для отбора
//
&НаСервереБезКонтекста
Функция ЭлементОтбораФизЛица(ПараметрыПолученияСотрудников)
	
	Если ПараметрыПолученияСотрудников.ТолькоНепринятые Тогда 
		Запрос = Новый Запрос;
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	СотрудникиСрезПоследних.ФизЛицо,
		|	СотрудникиСрезПоследних.ВидСобытия
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(&Период, Организация = &Организация) КАК СотрудникиСрезПоследних
		|ГДЕ
		|	НЕ СотрудникиСрезПоследних.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)";
		Запрос.УстановитьПараметр("Период", ПараметрыПолученияСотрудников.КонецПериода);
		
		Если ЗначениеЗаполнено(ПараметрыПолученияСотрудников.Организация) Тогда 
			Запрос.УстановитьПараметр("Организация", ПараметрыПолученияСотрудников.Организация);
		Иначе
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Организация = &Организация", "истина");	
		КонецЕсли;
		
		Запрос.Текст = ТекстЗапроса;
		Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ФизЛицо");
		
	Иначе 	
		Запрос = Новый Запрос;
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Сотрудники.ФизЛицо
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(&НачалоПериода, Организация = &Организация) КАК Сотрудники
		|ГДЕ
		|	НЕ Сотрудники.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)
		|	И Сотрудники.Подразделение = &Подразделение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Сотрудники.ФизЛицо
		|ИЗ
		|	РегистрСведений.Сотрудники КАК Сотрудники
		|ГДЕ
		|	Сотрудники.Период МЕЖДУ &НачалоПериода И &КонецПериода
		|	И Сотрудники.Организация = &Организация
		|	И Сотрудники.Подразделение = &Подразделение
		|	И Сотрудники.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Прием)";
		Запрос.УстановитьПараметр("НачалоПериода", ПараметрыПолученияСотрудников.НачалоПериода);
		Запрос.УстановитьПараметр("КонецПериода", ПараметрыПолученияСотрудников.КонецПериода);
		
		Если ЗначениеЗаполнено(ПараметрыПолученияСотрудников.Организация) Тогда 
			Запрос.УстановитьПараметр("Организация", ПараметрыПолученияСотрудников.Организация);
		Иначе
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Сотрудники.Организация = &Организация", "истина");	
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Организация = &Организация", "истина");	
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(ПараметрыПолученияСотрудников.Подразделение) Тогда 
			Запрос.УстановитьПараметр("Подразделение", ПараметрыПолученияСотрудников.Подразделение);
		Иначе
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Сотрудники.Подразделение = &Подразделение", "истина");	
		КонецЕсли;	
		
		Запрос.Текст = ТекстЗапроса;
		Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ФизЛицо");
		
	КонецЕсли;	
КонецФункции // Отбор()

// Процедура - обработчик события ПриИзменении поля ввода ОтключитьОтборПоПериодуИлиОрганизации.
//
&НаКлиенте
Процедура ОтключитьОтборПоПериодуИлиОрганизацииПриИзменении(Элемент)
	ЭлементыОтбора = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(Список.Отбор, "Ссылка");
	Для каждого ЭлементОтбора Из ЭлементыОтбора Цикл
		ЭлементОтбора.Использование = НЕ ОтключитьОтборПоПериодуИлиОрганизации;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработатьОповещениеОВыборе(Элемент, Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОповещениеОВыборе(Элемент, Значение)
	
	Если Элемент.РежимВыбора И НЕ ЗакрыватьПриВыборе Тогда
		ОбновитьСписокПодобранных(Значение);
	КонецЕсли;
	
	ОповеститьОВыборе(Значение);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокПодобранных(Значение)
	
	Если ТипЗнч(Значение) = Тип("Массив") Тогда
		
		Для каждого ВыбранноеЗначение Из Значение Цикл
			СписокПодобранных.Добавить(ВыбранноеЗначение);
		КонецЦикла;
		
	Иначе
		СписокПодобранных.Добавить(Значение);
	КонецЕсли;
	
	УстановитьСписокПодобранныхСотрудников();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСписокПодобранныхСотрудников()
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список,
		"СписокПодобранных",
		СписокПодобранных.ВыгрузитьЗначения());
		
КонецПроцедуры

#КонецОбласти
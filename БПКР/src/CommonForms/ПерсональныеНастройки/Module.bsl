
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("ПараметрыОткрытия", ПараметрыОткрытия);
	
	ОсновнаяОрганизация   = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	ОсновноеПодразделение = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновноеПодразделениеОрганизации");
	ОсновнойСклад         = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнойСклад");
	ОсновноеОснованиеУвольнения	  = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновноеОснованиеУвольнения");
	ОсновнаяСтатьяТрудовогоКодекса= БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяСтатьяТрудовогоКодекса");
	
	//Элементы.НастройкаСинхронизацииСКалендаремGoogle.Видимость = СинхронизацияСКалендаремGoogle.ДоступнаНастройкаСинхронизации();
	
	ЗапрашиватьПодтверждениеПриЗавершенииПрограммы = СтандартныеПодсистемыСервер.ЗапрашиватьПодтверждениеПриЗавершенииПрограммы();
	ЗначениеРабочейДаты = ОбщегоНазначения.РабочаяДатаПользователя();
	
	ТекущаяОрганизация                             = ОсновнаяОрганизация;
	ТекущееПодразделение                           = ОсновноеПодразделение;
	ТекущийСклад                                   = ОсновнойСклад;
	ТекущееОсновноеОснованиеУвольнения             = ОсновноеОснованиеУвольнения;
	ТекущаяСтатьяТрудовогоКодекса				   = ОсновнаяСтатьяТрудовогоКодекса;

	Если ЗначениеЗаполнено(ЗначениеРабочейДаты) Тогда
		ИспользоватьТекущуюДатуКомпьютера = 1;
	Иначе
		ИспользоватьТекущуюДатуКомпьютера = 0;
		ЗначениеРабочейДаты = '0001-01-01';
	КонецЕсли;
	
	ТолькоПросмотр = Не ПравоДоступа("СохранениеДанныхПользователя", Метаданные);
	
	// СтандартныеПодсистемы.РаботаСФайлами
	
	ЭтоВебКлиент = ОбщегоНазначения.ЭтоВебКлиент();
	
	Если ЭтоВебКлиент Или Не ОбщегоНазначения.ЭтоWindowsКлиент() Тогда
		Элементы.НастройкаСканирования.Видимость = Ложь;
	КонецЕсли;
	
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	УправлениеФормой(ЭтаФорма);
	
	// СтандартныеПодсистемы.Пользователи
	АвторизованныйПользователь = Пользователи.АвторизованныйПользователь();
	// Конец СтандартныеПодсистемы.Пользователи
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ТипЗнч(ПараметрыОткрытия) = Тип("Структура") Тогда

		АктивныйЭлемент = Неопределено;
		ПараметрыОткрытия.Свойство("АктивныйЭлемент", АктивныйЭлемент);

		Если ТипЗнч(АктивныйЭлемент) = Тип("Строка") Тогда
			ТекущийЭлемент = Элементы.Найти(АктивныйЭлемент);
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	КорректныйПериод = ОбщегоНазначенияБПСобытия.КорректныйПериодВводаДокументов();
	
	РабочаяДатаУказываетсяПользователем = ИспользоватьТекущуюДатуКомпьютера = 1;
	
	Если РабочаяДатаУказываетсяПользователем Тогда
		Если ЗначениеРабочейДаты < КорректныйПериод.НачалоКорректногоПериода Тогда
			ГраницаКорректности = Формат(КорректныйПериод.НачалоКорректногоПериода, "ДФ=гггг");
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Рабочая дата должна быть не ранее %1 года'"), ГраницаКорректности);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "ЗначениеРабочейДаты",, Отказ);
		ИначеЕсли ЗначениеРабочейДаты > КорректныйПериод.КонецКорректногоПериода Тогда
			ГраницаКорректности = Формат(КорректныйПериод.КонецКорректногоПериода, "ДФ=гггг");
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Рабочая дата должна быть не позже %1 года'"), ГраницаКорректности);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "ЗначениеРабочейДаты",, Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	Если Модифицированность Тогда
		Отказ = Истина;
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru='Данные были изменены. Сохранить изменения?'"), РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АвторизованныйПользовательНажатие(Элемент, СтандартнаяОбработка)
	
	ПоказатьЗначение(, АвторизованныйПользователь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьТекущуюДатуКомпьютераПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
	Если ИспользоватьТекущуюДатуКомпьютера = 0 Тогда
		ЗначениеРабочейДаты = '0001-01-01';
	ИначеЕсли ИспользоватьТекущуюДатуКомпьютера = 1 Тогда
		ЗначениеРабочейДаты = ТекущаяДата();
	КонецЕсли;
	Модифицированность = Истина;

КонецПроцедуры

&НаКлиенте
Процедура НастройкаСинхронизацииСКалендаремGoogle(Команда)
	
	ПоказатьПредупреждение(,НСтр("ru = 'В разработке.'"), 10);
	//ОбщегоНазначенияБПКлиент.ОткрытьФормуНастройкиСинхронизацииСКалендаремGoogle();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть()
	
	Если ЗаписатьДанные() Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСканирования(Команда)
	
	РаботаСФайламиКлиент.ОткрытьФормуНастройкиСканирования();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСтиляПриложения(Команда)
	ОткрытьФорму("ОбщаяФорма.ФормаНастрокиСтиляПриложения",, ЭтаФорма);		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СохранитьНастройкиСервер()
	
	Настройки = Новый Структура;
	Настройки.Вставить("ЗапрашиватьПодтверждениеПриЗавершенииПрограммы", ЗапрашиватьПодтверждениеПриЗавершенииПрограммы);
	ОбщегоНазначения.СохранитьПерсональныеНастройки(Настройки);
	
	ОбщегоНазначенияБПВызовСервера.УстановитьЗначениеПоУмолчанию("ОсновнаяОрганизация",              ОсновнаяОрганизация);
	ОбщегоНазначенияБПВызовСервера.УстановитьЗначениеПоУмолчанию("ОсновноеПодразделениеОрганизации", ОсновноеПодразделение);
	ОбщегоНазначенияБПВызовСервера.УстановитьЗначениеПоУмолчанию("ОсновнойСклад",                    ОсновнойСклад);
	ОбщегоНазначенияБПВызовСервера.УстановитьЗначениеПоУмолчанию("ОсновноеОснованиеУвольнения",      ОсновноеОснованиеУвольнения);
	ОбщегоНазначенияБПВызовСервера.УстановитьЗначениеПоУмолчанию("ОсновнаяСтатьяТрудовогоКодекса",   ОсновнаяСтатьяТрудовогоКодекса);

	Если ИспользоватьТекущуюДатуКомпьютера = 0 Тогда
		ЗначениеРабочейДатыДляСохранения  = '0001-01-01';
	Иначе
		ЗначениеРабочейДатыДляСохранения  = ЗначениеРабочейДаты;
	КонецЕсли;
	ОбщегоНазначения.УстановитьРабочуюДатуПользователя(ЗначениеРабочейДатыДляСохранения);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаКлиенте
Функция ЗаписатьДанные()
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Настройки = Новый Структура;
	Настройки.Вставить("ЗапрашиватьПодтверждениеПриЗавершенииПрограммы", ЗапрашиватьПодтверждениеПриЗавершенииПрограммы);
	ОбщегоНазначенияКлиент.СохранитьПерсональныеНастройки(Настройки);
	
	СохранитьНастройкиСервер();
	
	Если ТекущаяОрганизация <> ОсновнаяОрганизация Тогда
		Оповестить("ИзменениеОсновнойОрганизации", ОсновнаяОрганизация);
	КонецЕсли;
	ТекущаяОрганизация = ОсновнаяОрганизация;
	
	Если ТекущееПодразделение <> ОсновноеПодразделение Тогда
		Оповестить("ИзменениеОсновногоПодразделенияОрганизации", ОсновноеПодразделение);
	КонецЕсли;
	ТекущееПодразделение = ОсновноеПодразделение;
	
	Если ТекущийСклад <> ОсновнойСклад Тогда
		Оповестить("ИзменениеОсновногоСклада", ОсновнойСклад);
	КонецЕсли;
	ТекущийСклад = ОсновнойСклад;
	
	Если ТекущееОсновноеОснованиеУвольнения <> ОсновноеОснованиеУвольнения Тогда
		Оповестить("ИзменениеОсновногоОснованияУвольнения", ОсновноеОснованиеУвольнения);
	КонецЕсли;
	ТекущееОсновноеОснованиеУвольнения = ОсновноеОснованиеУвольнения;

	Если ТекущаяСтатьяТрудовогоКодекса <> ОсновнаяСтатьяТрудовогоКодекса Тогда
		Оповестить("ИзменениеОсновнойСтатьиТрудовогоКодекса", ОсновнаяСтатьяТрудовогоКодекса);
	КонецЕсли;
	ТекущаяСтатьяТрудовогоКодекса = ОсновнаяСтатьяТрудовогоКодекса;
	
	Модифицированность = Ложь;
	
	ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	
	Возврат Истина;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Форма.Элементы.ЗначениеРабочейДаты.Доступность  = Форма.ИспользоватьТекущуюДатуКомпьютера = 1;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаписатьИЗакрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

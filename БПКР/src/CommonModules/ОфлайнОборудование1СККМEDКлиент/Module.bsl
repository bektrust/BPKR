
#Область ПрограммныйИнтерфейс

// Процедура начинает выполнение команды, обрабатывает и перенаправляет на исполнение команду к драйверу.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения
//  Команда - Строка
//  ВходныеПараметры - Структура - Может быть передано неопределено
//  ОбъектДрайвера - Структура
//  Параметры - Структура
//  ПараметрыПодключения - Структура
//
Процедура НачатьВыполнениеКоманды(ОповещениеПриЗавершении, Команда, ВходныеПараметры, ОбъектДрайвера, Параметры, ПараметрыПодключения = Неопределено) Экспорт
	
	ВыходныеПараметры = Новый Массив();
	
	// Выгрузка данных
	Если Команда = "ВыгрузитьДанные" Тогда
		
		НачатьВыгрузкуДанных(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры);
		
	// Загрузка данных
	ИначеЕсли Команда = "ЗагрузитьДанные" Тогда
		
		НачатьЗагрузкуДанных(ОповещениеПриЗавершении, Параметры, ВыходныеПараметры);
		
	// Определяет результат загрузки отчета.
	ИначеЕсли Команда = "УстановитьФлагДанныеЗагружены" Тогда
		НачатьУстановкуФлагаДанныеЗагружены(ОповещениеПриЗавершении, Параметры, ВыходныеПараметры);
		
	// Тестирование устройства
	ИначеЕсли Команда = "ТестУстройства" ИЛИ Команда = "CheckHealth" Тогда
		НачатьТестУстройства(ОповещениеПриЗавершении, Параметры, ВыходныеПараметры);
		
	Иначе
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Команда ""%Команда%"" не поддерживается данным драйвером.'"));
		ВыходныеПараметры[1] = СтрЗаменить(ВыходныеПараметры[1], "%Команда%", Команда);
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ВыходныеПараметры);
		Если ОповещениеПриЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, РезультатВыполнения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СинхронныеПроцедурыИФункции

// Функция осуществляет проверку путей по которым хранятся файлы обмена.
//
Функция ТестУстройства(Параметры, ВыходныеПараметры) 
	
	Результат = Истина;
	ТекстОшибкиОбщий = "";
	ВремПараметр = "";
	
	Параметры.Свойство("КаталогОбмена", ВремПараметр);
	Если ПустаяСтрока(ВремПараметр) Тогда
		Результат = Ложь;
		ТекстОшибкиОбщий = НСтр("ru='Каталог обмена не указан'");
	КонецЕсли;
	
	Параметры.Свойство("ИмяФайлаЗагрузки", ВремПараметр);
	Если ПустаяСтрока(ВремПараметр) Тогда
		Результат = Ложь;
		ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС); 
		ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru='Имя файла выгрузки не указано'");
	КонецЕсли;
	
	Параметры.Свойство("ИмяФайлаВыгрузки", ВремПараметр);
	Если ПустаяСтрока(ВремПараметр) Тогда
		Результат = Ложь;
		ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС);
		ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru='Имя файла загрузки не указано'");
	КонецЕсли;
	
	Если Результат Тогда
		Если НРег(Параметры.ИмяФайлаВыгрузки) = НРег(Параметры.ИмяФайлаЗагрузки) Тогда
			Результат = Ложь;
			ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС); 
			ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru='Имена файлов загрузки и выгрузки не должны совпадать'");
		КонецЕсли;
	КонецЕсли;
			
	ВыходныеПараметры.Добавить(?(Результат, 0, 999));
	Если НЕ ПустаяСтрока(ТекстОшибкиОбщий) Тогда
		ВыходныеПараметры.Добавить(ТекстОшибкиОбщий);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область АсинхронныеПроцедурыИФункции

#Область КомандаВыгрузкаДанных

// Процедура осуществляет выгрузку таблицы товаров в ККМ, подключенную в режиме Offline.
//
Процедура НачатьВыгрузкуДанных(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры)
	
	Каталог = ДополнитьИмяКаталогаСлешем(Параметры.КаталогОбмена);
	ИмяФайла = Параметры.ИмяФайлаВыгрузки;

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ВыходныеПараметры", ВыходныеПараметры);
	ДополнительныеПараметры.Вставить("Параметры", Параметры);
	ДополнительныеПараметры.Вставить("ВходныеПараметры", ВходныеПараметры);

	Описание = Новый ОписаниеОповещения("ОповещениеПоискФайловВыгрузкиДанных", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПоискФайлов(Описание, Каталог, ИмяФайла + "*.*", Ложь);

КонецПроцедуры

Процедура ОповещениеПоискФайловВыгрузкиДанных(НайденныеФайлы, ДополнительныеПараметры) Экспорт
	
	ИменаФайлов = Новый Массив;
	
	Для Каждого ТекФайл Из НайденныеФайлы Цикл
		ИменаФайлов.Добавить(ТекФайл.ПолноеИмя);
	КонецЦикла;
	
	ОписаниеЗавершенияПолученияСодержания = Новый ОписаниеОповещения("НачатьВыгрузкуДанныхПродолжение", ЭтотОбъект, ДополнительныеПараметры);
	МенеджерОфлайнОборудованияКлиент.ПолучитьСодержаниеТекстовыхФайлов(ИменаФайлов, ОписаниеЗавершенияПолученияСодержания);
	
КонецПроцедуры

// Выгружает данные на офлайн-оборудование.
// Параметры:
// Результат - Структура - структура результат.
// ДополнительныеПараметры - Структура - где:
//  *Параметры - Структура - .
Процедура НачатьВыгрузкуДанныхПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Отказ = Ложь;
	
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	
	Если Результат.Успешно Тогда
		МассивФайлов = Новый Массив;
		Для Каждого СодержаниеФайла Из Результат.СодержаниеФайлов Цикл
			МассивФайлов.Добавить(СодержаниеФайла.ТекстСодержания);
		КонецЦикла;
		
		ПакетыОбработаны = Ложь;
		ОфлайнОборудование1СККМEDВызовСервера.ПакетыОбработаны(Отказ, ПакетыОбработаны, Истина, МассивФайлов, ВыходныеПараметры);
		
		Если НЕ Отказ И НЕ ПакетыОбработаны Тогда
			СоздатьСообщениеОбОшибке(ВыходныеПараметры, НСтр("ru='Файл предыдущей выгрузки не обработан (загружен)'"));
			Отказ = Истина;
		КонецЕсли;
	Иначе
		СоздатьСообщениеОбОшибке(ВыходныеПараметры, Результат.ТекстОшибки);
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		ОповещениеЗавершение = Новый ОписаниеОповещения("НачатьВыгрузкуДанныхЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ВыполнитьОбработкуОповещения(ОповещениеЗавершение);
	Иначе
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Выгружает данные на офлайн-оборудование.
// Параметры:
// Результат - Структура - структура результат.
// ДополнительныеПараметры - Структура - где:
//  *Параметры - Структура - .
Процедура НачатьВыгрузкуДанныхЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.БазоваяФункциональность") Тогда

		ДанныеВыгрузки = ДополнительныеПараметры.ВходныеПараметры.ДанныеДляВыгрузки;
		ДанныеВыгрузки.Вставить("Параметры", ДополнительныеПараметры.Параметры);
		ДлительнаяОперация = ОфлайнОборудование1СККМEDВызовСервера.ВыгрузитьДанныеНаСервере(ДанныеВыгрузки);
		
		МодульДлительныеОперацииКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ДлительныеОперацииКлиент");
		ПараметрыОжидания = МодульДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииОперацииВыгрузки", ЭтотОбъект, ДополнительныеПараметры);
		МодульДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
	Иначе
		ДополнительныеПараметры.ВыходныеПараметры.Добавить("999");
		ДополнительныеПараметры.ВыходныеПараметры.Добавить(НСтр("ru='Операция невозможна, отсутствует подсистема Обмен данными.'"));

		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ДополнительныеПараметры.ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры
	
Процедура ПриЗавершенииОперацииВыгрузки(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ЗаписатьРезультатВыгрузкиВФайл(Результат.АдресРезультата, ДополнительныеПараметры);
	Иначе
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ДополнительныеПараметры.ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьРезультатВыгрузкиВФайл(АдресХраненияРезультата, ДополнительныеПараметры)

	Параметры = ДополнительныеПараметры.Параметры;
	Каталог = ДополнитьИмяКаталогаСлешем(Параметры.КаталогОбмена);
	ИмяФайла = Параметры.ИмяФайлаВыгрузки;

	ПутьКФайлуВыгрузки = Каталог + ИмяФайла + ".xml";
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьРезультатВыгрузкиВФайлЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.БазоваяФункциональность") Тогда
		МодульФайловаяСистемаКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ФайловаяСистемаКлиент");
		
		ПараметрыСохранения = МодульФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
		ПараметрыСохранения.Интерактивно = Ложь;

		МодульФайловаяСистемаКлиент.СохранитьФайл(
			Оповещение,
			АдресХраненияРезультата,
			ПутьКФайлуВыгрузки,
			ПараметрыСохранения);
	Иначе
		ВыполнитьОбработкуОповещения(Оповещение);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьРезультатВыгрузкиВФайлЗавершение(ПолученныеФайлы, ДополнительныеПараметры) Экспорт
	
	Результат = ПолученныеФайлы <> Неопределено;
	
	РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Результат, ДополнительныеПараметры.ВыходныеПараметры);
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

#Область КомандаЗагрузкаДанных

Процедура НачатьЗагрузкуДанных(ОповещениеПриЗавершении, Параметры, ВыходныеПараметры)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ВыходныеПараметры", 		ВыходныеПараметры);
	ДополнительныеПараметры.Вставить("Параметры", 				Параметры);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НачатьЗагрузкуДанныхЗавершение", ЭтотОбъект, ДополнительныеПараметры);

	НачатьЗагрузкуИзФайла(ОписаниеОповещения, Параметры);

КонецПроцедуры

Процедура НачатьЗагрузкуДанныхЗавершение(АдресФайлаЗагрузки, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(АдресФайлаЗагрузки)
		И ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.БазоваяФункциональность") Тогда

		ДлительнаяОперация = ОфлайнОборудование1СККМEDВызовСервера.ЗагрузитьДанныеНаСервере(АдресФайлаЗагрузки);
		
		МодульДлительныеОперацииКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ДлительныеОперацииКлиент");
		ПараметрыОжидания = МодульДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииОперацииЗагрузки", ЭтотОбъект, ДополнительныеПараметры);
		МодульДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
	Иначе
		ДополнительныеПараметры.ВыходныеПараметры.Добавить(999);
		ДополнительныеПараметры.ВыходныеПараметры.Добавить(НСтр("ru='Операция невозможна, отсутствует подсистема Обмен данными.'"));

		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ДополнительныеПараметры.ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗавершенииОперацииЗагрузки(Результат, ДополнительныеПараметры) Экспорт
	
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	ВыходныеПараметры.Добавить(ДанныеИзККМ()); // Передаем в БПО пустую структуру, т.к. все данные загружены подсистемой обмена.
	
	РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Истина, ВыходныеПараметры);
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
	
КонецПроцедуры

Процедура НачатьЗагрузкуИзФайла(ОписаниеОповещения, Параметры)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОписаниеОповещения);

	Каталог = ДополнитьИмяКаталогаСлешем(Параметры.КаталогОбмена);
	ИмяФайла = Параметры.ИмяФайлаЗагрузки;
	ПутьКФайлуЗагрузки = Каталог + ИмяФайла + ".xml";
 
	Оповещение = Новый ОписаниеОповещения("ПоместитьФайлВХранилищеЗавершить", ЭтотОбъект, ДополнительныеПараметры);
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.БазоваяФункциональность") Тогда
		МодульФайловаяСистемаКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ФайловаяСистемаКлиент");

		ПараметрыЗагрузки = МодульФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
		
		Если ЗначениеЗаполнено(ПутьКФайлуЗагрузки) Тогда
			ПараметрыЗагрузки.Интерактивно = Ложь;
			МодульФайловаяСистемаКлиент.ЗагрузитьФайл(Оповещение, ПараметрыЗагрузки, ПутьКФайлуЗагрузки);
		КонецЕсли;
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоместитьФайлВХранилищеЗавершить(ПомещенныйФайл, ДополнительныеПараметры) Экспорт
	
	АдресФайлаЗагрузки = "";
	Если ПомещенныйФайл <> Неопределено Тогда
		АдресФайлаЗагрузки = ПомещенныйФайл.Хранение;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, АдресФайлаЗагрузки);
	
КонецПроцедуры

#КонецОбласти

#Область КомандаУстановкиФлага

Процедура НачатьУстановкуФлагаДанныеЗагружены(ОповещениеПриЗавершении, Параметры, ВыходныеПараметры)
	
	Каталог = ДополнитьИмяКаталогаСлешем(Параметры.КаталогОбмена);
	ИмяФайла = Параметры.ИмяФайлаЗагрузки;

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ВыходныеПараметры", ВыходныеПараметры);
	ДополнительныеПараметры.Вставить("Параметры", Параметры);

	Описание = Новый ОписаниеОповещения("ОповещениеПоискФайловУстановкаФлагаДанныеЗагружены", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПоискФайлов(Описание, Каталог, ИмяФайла + "*.*", Ложь);

КонецПроцедуры

// Оповещает о поиске файлов загруженных данных.
// Параметры:
// НайденныеФайлы - Массив - структура результат.
// ДополнительныеПараметры - Структура - где:
//  *Параметры - Структура - .
Процедура ОповещениеПоискФайловУстановкаФлагаДанныеЗагружены(НайденныеФайлы, ДополнительныеПараметры) Экспорт
	
	ИменаФайлов = Новый Массив;
	
	Для Каждого ТекФайл Из НайденныеФайлы Цикл
		ИменаФайлов.Добавить(ТекФайл.ПолноеИмя);
	КонецЦикла;
	
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	Успешно = УстановитьФлагДанныеЗагружены(ИменаФайлов, ВыходныеПараметры);
	
	РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Успешно, ВыходныеПараметры);
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
	
КонецПроцедуры

Функция УстановитьФлагДанныеЗагружены(ИменаФайлов, ВыходныеПараметры)
	
	Для Каждого ИмяФайла Из ИменаФайлов Цикл
		
		ТекстXML = ОфлайнОборудование1СККМEDВызовСервера.ПолучитьТекстXMLДанныеЗагружены();
		
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.УстановитьТекст(ТекстXML);
		
		
		Результат = МенеджерОфлайнОборудованияКлиент.ЗаписатьТекстовыйФайл(ТекстовыйДокумент, ИмяФайла);
	
		Если Не Результат Тогда
			СоздатьСообщениеОбОшибке(ВыходныеПараметры, НСтр("ru = 'Не удалось записать файл.'"));
			Возврат Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область ТестУстройства

// Процедура осуществляет тестирование устройства.
//
Процедура НачатьТестУстройства(ОповещениеПриЗавершении, Параметры, ВыходныеПараметры)
	
	Результат = ТестУстройства(Параметры, ВыходныеПараметры);
	РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Результат, ВыходныеПараметры);
	ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, РезультатВыполнения);
	
КонецПроцедуры
	
#КонецОбласти

#КонецОбласти

#Область ОбщиеПроцедурыИФункции

// Дополнить имя каталога слешем.
// 
// Параметры:
//  ИмяКаталога - Строка - Имя каталога
// 
// Возвращаемое значение:
//  Строка.
Функция ДополнитьИмяКаталогаСлешем(Знач ИмяКаталога)
	
	Если Найти(ИмяКаталога, "ftp") > 0 Тогда
		Слеш = "/";
	Иначе
		Слеш = "\";
	КонецЕсли;
	
	Если НЕ Прав(ИмяКаталога,1) = Слеш Тогда
		ИмяКаталога = ИмяКаталога + Слеш;
	КонецЕсли;
	
	Возврат ИмяКаталога;
	
КонецФункции

// Процедура добавляет в массив выходных параметров сообщение об ошибке.
//		Параметры:
//			- ВыходныеПараметры - массив, в который будет помещено сообщение об ошибке.
//			- ТекстСообщения - текст сообщения, содержащий информация об ошибке.
Процедура СоздатьСообщениеОбОшибке(ВыходныеПараметры, ТекстСообщения)
	
	ВыходныеПараметры.Добавить(999);
	ВыходныеПараметры.Добавить(ТекстСообщения);
	
КонецПроцедуры

Функция ДанныеИзККМ()
	
	ЗагружаемыеДанные = Новый Структура;
	
	ЗагружаемыеДанные.Вставить("ОтчетыОПродажах", Новый Массив);
	ЗагружаемыеДанные.Вставить("ВскрытияАлкогольнойТары", Новый Массив);
	
	Возврат ЗагружаемыеДанные;
	
КонецФункции

#КонецОбласти

#КонецОбласти


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
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();

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
	
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	Если Не Объект.Годовой Тогда
		Объект.ДатаНачала 		= НачалоКвартала(Объект.ДатаНачала);
		Объект.ДатаОкончания 	= КонецКвартала(Объект.ДатаНачала);
	Иначе 
		Объект.ДатаНачала 		= НачалоКвартала(Объект.ДатаНачала);
		Объект.ДатаОкончания 	= КонецГода(Объект.ДатаНачала);		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГодовойПриИзменении(Элемент)
	
	Если Не Объект.Годовой Тогда
		Объект.ДатаНачала 		= НачалоКвартала(Объект.ДатаНачала);
		Объект.ДатаОкончания 	= КонецКвартала(Объект.ДатаНачала);
	Иначе 
		Объект.ДатаНачала 		= НачалоКвартала(Объект.ДатаНачала);
		Объект.ДатаОкончания 	= КонецГода(Объект.ДатаНачала);		
	КонецЕсли;
	
	Объект.Отчет.Очистить();
	Объект.ОтчетГодовой.Очистить();
	УстановитьВидимостьДоступностьЭлементов();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если Объект.Отчет.Количество() > 0 Или Объект.ОтчетГодовой.Количество() > 0 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьТабличнуюЧастьОтчет", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет очищена и перезаполнена. Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ЗаполнитьТабличнуюЧастьОтчетНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузкаExcel(Команда)
	
	Если ТребуетсяНастройкаАвторизацияИнтернетПоддержки() Тогда
		ТекстВопроса = НСтр("ru='Для формирования отчета в электронной форме
			|необходимо подключиться к Интернет-поддержке пользователей.
			|Подключиться сейчас?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриПодключенииИнтернетПоддержки", ЭтотОбъект);
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Подключиться'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
	Иначе
		ПродолжитьВыгрузку();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузкаExcelГодовой(Команда)
	
	Если ТребуетсяНастройкаАвторизацияИнтернетПоддержки() Тогда
		ТекстВопроса = НСтр("ru='Для формирования отчета в электронной форме
			|необходимо подключиться к Интернет-поддержке пользователей.
			|Подключиться сейчас?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриПодключенииИнтернетПоддержки", ЭтотОбъект);
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Подключиться'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
	Иначе
		ПродолжитьВыгрузку();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьТабличнуюЧастьОтчет(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.Отчет.Очистить();
		Объект.ОтчетГодовой.Очистить();
		ЗаполнитьТабличнуюЧастьОтчетНаСервере();
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПроводник(ДополнительныеПараметры) Экспорт
	Если ЗначениеЗаполнено(ДополнительныеПараметры.ПолноеИмяФайла) Тогда 
		ФайловаяСистемаКлиент.ОткрытьПроводник(ДополнительныеПараметры.ПолноеИмяФайла);
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Элементы.СтраницаОтчет.Видимость 		= Не Объект.Годовой;
	Элементы.СтраницаОтчетГодовой.Видимость	= Объект.Годовой;
	Элементы.ВыгрузкаExcel.Видимость 		= Не Объект.Годовой;
	Элементы.ВыгрузкаExcelГодовой.Видимость = Объект.Годовой;
	
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

&НаСервере
Процедура ЗаполнитьТабличнуюЧастьОтчетНаСервере()
	
	Документ = РеквизитФормыВЗначение("Объект");
	Если Не Объект.Годовой Тогда
		Документ.ЗаполнитьТабличнуюЧастьОтчет();
	Иначе 	
		Документ.ЗаполнитьТабличнуюЧастьОтчетГодовой();
	КонецЕсли; 
	ЗначениеВРеквизитФормы(Документ, "Объект");
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Функция ТребуетсяНастройкаАвторизацияИнтернетПоддержки()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		МодульИнтернетПоддержкаПользователей = ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователей");
		Возврат Не МодульИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
	КонецЕсли;
	Возврат Ложь;
КонецФункции

&НаКлиенте
Процедура ПриПодключенииИнтернетПоддержки(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПодключенияИнтернетПоддержки", ЭтотОбъект);
		МодульИнтернетПоддержкаПользователейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтернетПоддержкаПользователейКлиент");
		МодульИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(ОписаниеОповещения, ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеПодключенияИнтернетПоддержки(Результат, ДополнительныеПараметры) Экспорт
	Если Не (ТипЗнч(Результат) = Тип("Структура")
		И ЗначениеЗаполнено(Результат.Логин)) Тогда
		Возврат;
	КонецЕсли;
	
	ПродолжитьВыгрузку();	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьВыгрузку()
	
	Если Объект.Ссылка.Пустая() Или Модифицированность Тогда  
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
			|Выполнение действия возможно только после записи данных.
			|Данные будут записаны.'");
		Обработчик = Новый ОписаниеОповещения("ПродолжитьВыполнениеКомандыПослеПодтвержденияЗаписи", ЭтотОбъект);
		ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		Возврат;
	КонецЕсли;		
	
	ПродолжитьВыгрузкуЗавершение();

КонецПроцедуры 

&НаКлиенте
Процедура ПродолжитьВыполнениеКомандыПослеПодтвержденияЗаписи(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		ОчиститьСообщения();
		Записать();
		Если Объект.Ссылка.Пустая() Или Модифицированность Тогда
			Возврат; // Запись не удалась, сообщения о причинах выводит платформа.
		КонецЕсли;
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	ПродолжитьВыгрузкуЗавершение()
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьВыгрузкуЗавершение()
 
	Оповещение = Новый ОписаниеОповещения("НачатьПодключениеРасширенияРаботыСФайламиЗавершение", ЭтотОбъект);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
КонецПроцедуры 

&НаКлиенте
Процедура НачатьПодключениеРасширенияРаботыСФайламиЗавершение(Подключено, ДополнительныеПараметры) Экспорт
	
	Если НЕ Подключено Тогда
		Оповещение = Новый ОписаниеОповещения("НачатьУстановкуРасширенияРаботыСФайламиЗавершение", ЭтотОбъект);
		ТекстСообщения = НСтр("ru = 'Для продолжении работы необходимо установить расширение для веб-клиента ""1С:Предприятие"". Установить?'");
		ПоказатьВопрос(Оповещение, ТекстСообщения, РежимДиалогаВопрос.ДаНет); 
	КонецЕсли;
	
	Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Укажите путь для сохранения файла'");
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ДиалогОткрытияФайлаЗавершение", ЭтотОбъект);
	ДиалогОткрытияФайла.Показать(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьУстановкуРасширенияРаботыСФайламиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		НачатьУстановкуРасширенияРаботыСФайлами();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДиалогОткрытияФайлаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено И ВыбранныеФайлы.Количество() > 0 Тогда
		ФормированиеФайла(ВыбранныеФайлы[0]);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ФормированиеФайла(КаталогФайлаВыгрузки)
	
	#Если ТонкийКлиент Тогда
		КаталогФайлаВыгрузки = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(КаталогФайлаВыгрузки);
		
		// Открытие приложения Excel
		Попытка
			Excel = Новый COMОбъект("Excel.Application");
		Исключение
			ВызватьИсключение НСтр("ru = 'Не удалось подключить COM-объект Excel.
				|Вероятные причины:
				| - На компьютере не установлен Microsoft Office или установлена не полная версия;
				| - У пользователя недостаточно прав на создание COM-объектов;
				| - Включен контроль учетных записей Windows;
				| - Операционная система не из семейства Windows.
				|
				|Техническая информация:
				|'") + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;
		
		Excel.Visible = 0;
		Excel.DisplayAlerts = 0;
		Excel.DefaultSaveFormat = 51;
		
		Расширение = "xlsx";
		ТипФайла = ТипФайлаТабличногоДокумента.XLSX;
		
		// Проверка версии
		ВерсияExcel = Лев(Excel.Version, Найти(Excel.Version,".") -1);
		Если ВерсияExcel < "16" Тогда
			ТекстСообщения = НСтр("ru = 'Используется устаревшая версия Excel. Возможны ошибки.'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
			
			// для сохранения в старом формате
			Excel.DefaultSaveFormat = 56;
			Расширение = "xls";  
			ТипФайла = ТипФайлаТабличногоДокумента.XLS;
		КонецЕсли;
		
		ПолноеИмяФайла = КаталогФайлаВыгрузки + "Отчет по выплатам и удержаниям ПН " 
							+ Формат(ДатаДокумента,"ДФ=yyyyMMdd") + "." + Расширение;

		ТабличныйДокументПриложение = ОтчетПоВыплатамИУдержаниямПН();
		ТабличныйДокументПриложение.Записать(ПолноеИмяФайла, ТипФайла);
		
		Книга = Excel.WorkBooks.Open(ПолноеИмяФайла);
		Лист = Книга.WorkSheets(1);
		
		Если Объект.Годовой Тогда
			КоличествоСтрок = Объект.ОтчетГодовой.Количество();
			
			Для Счетчик = 1 По КоличествоСтрок Цикл 
				Лист.Cells(Счетчик, 1).NumberFormat = "@";
				Лист.Cells(Счетчик, 2).NumberFormat = "@";
				Лист.Cells(Счетчик, 3).NumberFormat = "@";
				Лист.Cells(Счетчик, 4).NumberFormat = "0,00";
				Лист.Cells(Счетчик, 5).NumberFormat = "0,00";
				Лист.Cells(Счетчик, 6).NumberFormat = "0,00";
				Лист.Cells(Счетчик, 7).NumberFormat = "0,00";
			КонецЦикла;	
		Иначе	
			КоличествоСтрок = Объект.Отчет.Количество();
			
			Для Счетчик = 1 По КоличествоСтрок Цикл 
				Лист.Cells(Счетчик, 1).NumberFormat = "@";
				Лист.Cells(Счетчик, 2).NumberFormat = "@";
				Лист.Cells(Счетчик, 3).NumberFormat = "@";
				Лист.Cells(Счетчик, 4).NumberFormat = "@";
				Лист.Cells(Счетчик, 5).NumberFormat = "@";
				Лист.Cells(Счетчик, 6).NumberFormat = "0,00";
				Лист.Cells(Счетчик, 7).NumberFormat = "0,00";
			КонецЦикла;	
		КонецЕсли;	
		
		Книга.SaveAs(ПолноеИмяФайла);
		Книга.Close();
		
		// Закрытие приложения
		Excel.Quit();	
		Excel = Неопределено;
		
		ТекстОповещения = НСтр("ru = 'Файл сформирован'");
		ТекстПояснения = ПолноеИмяФайла;
		ПоказатьОповещениеПользователя(
			ТекстОповещения, 
			Новый ОписаниеОповещения("ОткрытьПроводник", ЭтотОбъект, Новый Структура("ПолноеИмяФайла", ПолноеИмяФайла)), 
			ТекстПояснения, 
			БиблиотекаКартинок.Информация32);
	#Иначе
	ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
	#КонецЕсли
КонецПроцедуры // ФормированиеФайла()

&НаСервере
Функция ОтчетПоВыплатамИУдержаниямПН()
	ТабличныйДокумент = Новый ТабличныйДокумент;													   
	
	Если Объект.Годовой Тогда
		Макет = Документы.ОтчетПоВыплатамИУдержаниямПН.ПолучитьМакет("ПФ_MXL_ОтчетПоВыплатамИУдержаниямПН_Годовой_Excel");
		
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		
		Для Каждого СтрокаТабличнойЧасти Из Объект.ОтчетГодовой Цикл
			ОбластьМакета.Параметры.Заполнить(СтрокаТабличнойЧасти);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
		
	Иначе	
		Макет = Документы.ОтчетПоВыплатамИУдержаниямПН.ПолучитьМакет("ПФ_MXL_ОтчетПоВыплатамИУдержаниямПН_Excel");
		
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ДокументыФизическихЛиц.ФизЛицо КАК ФизЛицо,
			|	ДокументыФизическихЛиц.Серия КАК Серия,
			|	ДокументыФизическихЛиц.Номер КАК Номер,
			|	ДокументыФизическихЛиц.КемВыдан КАК КемВыдан
			|ИЗ
			|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
			|ГДЕ
			|	ДокументыФизическихЛиц.Период <= &Период
			|	И ДокументыФизическихЛиц.ФизЛицо В (&СписокФизЛиц)
			|	И ДокументыФизическихЛиц.ВидДокумента = ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.Паспорт)
			|	И НЕ (ДокументыФизическихЛиц.Серия = """"
			|		И ДокументыФизическихЛиц.Номер = """"
			|		И ДокументыФизическихЛиц.КемВыдан = """")
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ГражданствоФизическихЛицСрезПоследних.ФизЛицо КАК ФизЛицо,
			|	ГражданствоФизическихЛицСрезПоследних.Страна.КодАльфа3 КАК КодСтраны
			|ИЗ
			|	РегистрСведений.ГражданствоФизическихЛиц.СрезПоследних(
			|			&Период,
			|			ФизЛицо В (&СписокФизЛиц)
			|				И НЕ Страна.КодАльфа3 = """") КАК ГражданствоФизическихЛицСрезПоследних";
		Запрос.УстановитьПараметр("Период", 		ДатаДокумента);
		Запрос.УстановитьПараметр("СписокФизЛиц", 	Объект.Отчет.Выгрузить(,"ФизЛицо").ВыгрузитьКолонку("ФизЛицо"));
		
		Результаты = Запрос.ВыполнитьПакет();
		
		ДанныеДокументов = Результаты[0].Выгрузить();
		ДанныеДокументов.Индексы.Добавить("ФизЛицо");
		
		ДанныеСтраны = Результаты[1].Выгрузить();
		ДанныеСтраны.Индексы.Добавить("ФизЛицо");
		
		Для Каждого СтрокаТабличнойЧасти Из Объект.Отчет Цикл
			ДанныеЗаполнения = Новый Структура();
			ДанныеЗаполнения.Вставить("ФизЛицо", 					СтрокаТабличнойЧасти.ФизЛицо.ФИО);
			ДанныеЗаполнения.Вставить("КодСтраны", 					"");
			ДанныеЗаполнения.Вставить("ДанныеФизЛица", 				"");
			ДанныеЗаполнения.Вставить("НомерНалоговойРегистрации", 	СтрокаТабличнойЧасти.НомерНалоговойРегистрации);
			ДанныеЗаполнения.Вставить("КодДохода", 					СтрокаТабличнойЧасти.КодДохода);
			
			СтрокаТаблицы = ДанныеДокументов.Найти(СтрокаТабличнойЧасти.ФизЛицо, "ФизЛицо");
			
			Если НЕ СтрокаТаблицы = Неопределено Тогда				
				ДанныеЗаполнения.ДанныеФизЛица = СтрШаблон("%1 %2, %3", 
					СтрокаТаблицы.Серия,
					СтрокаТаблицы.Номер,
					СтрокаТаблицы.КемВыдан);
			КонецЕсли;	
			
			СтрокаТаблицы = ДанныеСтраны.Найти(СтрокаТабличнойЧасти.ФизЛицо, "ФизЛицо");
			
			Если НЕ СтрокаТаблицы = Неопределено Тогда			
				ДанныеЗаполнения.КодСтраны = СтрокаТаблицы.КодСтраны;
			КонецЕсли;
			
			ОбластьМакета.Параметры.Заполнить(СтрокаТабличнойЧасти);
			ОбластьМакета.Параметры.Заполнить(ДанныеЗаполнения);
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;	
	КонецЕсли;	
		
	Возврат ТабличныйДокумент;	
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


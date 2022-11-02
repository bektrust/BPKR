#Область ОбработчикиСобытийФорм

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПравоДоступаСохранениеДанныхПользователя = ПравоДоступа("СохранениеДанныхПользователя", Метаданные);

	СозданиеНовогоЭлемента = Объект.Ссылка = Справочники.ПодключаемоеОборудование.ПустаяСсылка();
	
	// Защита от изменения уже созданного экземпляра устройства.
	Элементы.ДрайверОборудования.ТолькоПросмотр = НЕ СозданиеНовогоЭлемента;
	Элементы.ДрайверОборудования.КнопкаОткрытия = Не СозданиеНовогоЭлемента;
	Элементы.ТипОборудования.ТолькоПросмотр = НЕ СозданиеНовогоЭлемента;
	     
	Если СозданиеНовогоЭлемента Тогда 
		Если ПустаяСтрока(Объект.РабочееМесто) 
			И Объект.ТипПодключения = Перечисления.ТипыПодключенияОборудования.ЛокальноеПодключение Тогда
			Объект.РабочееМесто = МенеджерОборудованияВызовСервера.РабочееМестоКлиента();
		КонецЕсли;
		Объект.УстройствоИспользуется = Истина;
	КонецЕсли;
	
	ПроверкаПараметров = СозданиеНовогоЭлемента;
	
#Если МобильноеПриложениеСервер Тогда
	Элементы.РабочееМесто.Видимость = Ложь;
	Элементы.ПараметрыПодключения.Видимость = Ложь;
	Элементы.ТипПодключения.Видимость = Ложь;
	Элементы.ОграничениеДоступа.Видимость = Ложь;
#Иначе
	Элементы.РабочееМесто.Видимость = Объект.ТипПодключения = Перечисления.ТипыПодключенияОборудования.ЛокальноеПодключение;
	Элементы.ОграничениеДоступа.Видимость = Объект.ТипПодключения = Перечисления.ТипыПодключенияОборудования.ОбщийДоступ;
#КонецЕсли
	
	МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элементы.ТипПодключения);
	МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элементы.ТипОборудования);
	МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элементы.ДрайверОборудования);
	МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элементы.Организация);
	МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элементы.Наименование);
	МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элементы.РабочееМесто);
	МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элементы.СерийныйНомер);
	
	Если СозданиеНовогоЭлемента Тогда
		Если Объект.ТипПодключения = Перечисления.ТипыПодключенияОборудования.ОбщийДоступ Тогда
			Объект.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККТ;
			Элементы.ТипОборудования.ТолькоПросмотр = Истина;
		КонецЕсли;
		Элементы.ДрайверОборудования.РежимВыбораИзСписка = Истина;
		ЗаполнитьСписокДрайверов();
	КонецЕсли;
	
	ОбновитьИнтерфейсФормы();    
	
	МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияПриСозданииНаСервере(Объект, ЭтотОбъект, Отказ, Параметры, СтандартнаяОбработка);
	УстановитьВидимостьОрганизацииНаСервере();   
	
	Если МенеджерОборудованияВызовСервера.ИспользуетсяЧекопечатающиеУстройства() Тогда
		МодульОборудованиеЧекопечатающиеУстройстваВызовСервера = ОбщегоНазначения.ОбщийМодуль("ОборудованиеЧекопечатающиеУстройстваВызовСервера");
		МодульОборудованиеЧекопечатающиеУстройстваВызовСервера.ОбновитьПараметрыРегистрацииККТ(ПараметрыРегистрацииККТ, Объект.ПараметрыРегистрации);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияПриЧтенииНаСервере(ТекущийОбъект, ЭтотОбъект);
	
	// БПКР
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	// Конец БПКР
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не Отказ И Модифицированность Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	МенеджерОборудованияКлиентПереопределяемый.ЭкземплярОборудованияПередЗаписью(Объект, ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыУстройства = МенеджерОборудованияВызовСервера.ПараметрыУстройства(Объект.Ссылка);
	МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи);
	
	// БПКР
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	// Конец БПКР
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	СозданиеНовогоЭлемента = Ложь;
	
	Элементы.ПараметрыПодключения.Видимость = НЕ СозданиеНовогоЭлемента;
	
	ОбновитьИнтерфейсФормы();
	
	МенеджерОборудованияКлиентПереопределяемый.ЭкземплярОборудованияПослеЗаписи(Объект, ЭтотОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияОбработкаПроверкиЗаполненияНаСервере(Объект, ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если Модифицированность Или СозданиеНовогоЭлемента Тогда
			Если Записать() Тогда
				ПроверкаПараметров = Ложь;
				Закрыть();
			Иначе
				Возврат;
			КонецЕсли;
		Иначе
			ПроверкаПараметров = Ложь;
			Закрыть();
		КонецЕсли;
		МенеджерОборудованияКлиент.ВыполнитьНастройкуОборудования(Объект.Ссылка);
	Иначе
		ПроверкаПараметров = Ложь;
		Закрыть();
	КонецЕсли;   
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не Объект.Ссылка.Пустая() Тогда
		Если ПроверкаПараметров Тогда
			Отказ = Истина;
			Текст = НСтр("ru = 'Для использования устройства необходимо настроить параметры подключения.
			|Перейти к настройке параметров подключения?'");
			Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение",  ЭтотОбъект);
			ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
		КонецЕсли;
		
		МенеджерОборудованияКлиентПереопределяемый.ЭкземплярОборудованияПередЗакрытием(Объект, ЭтотОбъект, Отказ, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	МенеджерОборудованияКлиентПереопределяемый.ЭкземплярОборудованияОбработкаНавигационнойСсылки(Объект, ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура ТипОборудованияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Объект.ТипОборудования <> ВыбранноеЗначение Тогда
		Объект.ТипОборудования = ВыбранноеЗначение;
		Модифицированность = Истина;
		ЗаполнитьСписокДрайверов();
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ОбновитьИнтерфейсФормы();
	
	Если НЕ ОрганизацияВидимость Тогда
		Объект.Организация = Неопределено;
	КонецЕсли;
	
	МенеджерОборудованияКлиентПереопределяемый.ЭкземплярОборудованияТипОборудованияВыбор(Объект, ЭтотОбъект, ЭтотОбъект, Элемент, ВыбранноеЗначение);
	
	УстановитьВидимостьОрганизацииНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ДрайверОборудованияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение <> Объект.ДрайверОборудования Тогда
		Объект.Наименование = "'" + Строка(ВыбранноеЗначение) + "'"
						+ ?(ПустаяСтрока(Строка(Объект.РабочееМесто)),
							"",
							" " + НСтр("ru='на'") + " " + Строка(Объект.РабочееМесто));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДрайверОборудованияПриИзменении(Элемент)
	ОбновитьИнтерфейсФормы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПараметрыПодключения(Команда)
	
	Если СозданиеНовогоЭлемента Или Модифицированность Тогда
		Если Записать() Тогда
			ПроверкаПараметров = Ложь;
			Закрыть();
		Иначе
			Возврат;
		КонецЕсли;
	Иначе
		ПроверкаПараметров = Ложь;
		Закрыть();
	КонецЕсли;
	
	МенеджерОборудованияКлиент.ВыполнитьНастройкуОборудования(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура РегистрацияФискальногоНакопителя(Команда)
	
	ОперацияФискальногоНакопителя(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеПараметровРегистрацииФискальногоНакопителя(Команда)
	
	ОперацияФискальногоНакопителя(2);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытиеФискальногоНакопителя(Команда)
	
	ОперацияФискальногоНакопителя(3);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаСайтИнструкцииНажатие(Элемент)
	
	АдресЗагрузки = "https://its.1c.ru/db/metod81#browse:13:-1:2115:2511";
	ОткрытьНавигационнуюСсылку(АдресЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура СообщениеИнфоПисьмоОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	АдресЗагрузки = "https://its.1c.ru/bmk/envd_kkt";
	ОткрытьНавигационнуюСсылку(АдресЗагрузки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимостьОрганизацииНаКлиенте()
	
	Элементы.Организация.Видимость = ОрганизацияВидимость;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьОрганизацииНаСервере()
	
	Элементы.Организация.Видимость = ОрганизацияВидимость;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнтерфейсФормы();
	
	ТипОборудованияККТ = Объект.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККТ;
	ТипОборудованияФР  = Объект.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ФискальныйРегистратор;
	ТипОборудованияПЧ  = Объект.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ПринтерЧеков;
	ДрайверОнлайнКасса = Объект.ДрайверОборудования.ИдентификаторОбъекта = "ОнлайнКасса";
	
	ОрганизацияВидимость = ТипОборудованияККТ Или ТипОборудованияФР Или ТипОборудованияПЧ;

	Элементы.ФискальныеДанные.Видимость = ТипОборудованияККТ И НЕ СозданиеНовогоЭлемента И Не ДрайверОнлайнКасса;
	Элементы.ПринтерДляПечати.Видимость = ТипОборудованияККТ И ДрайверОнлайнКасса;
	
	Если Элементы.ФискальныеДанные.Видимость Или Элементы.ОграничениеДоступа.Видимость Тогда
		Элементы.Закладки.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху       
	Иначе
		Элементы.Закладки.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
	Элементы.Организация.Видимость = ОрганизацияВидимость; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацияФискальногоНакопителя_Завершение(РезультатВыполнения, Параметры) Экспорт
	
	ОчиститьСообщения();
	
	Если РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр("ru='Операция завершена.'");
	Иначе
		ТекстСообщения = РезультатВыполнения.ОписаниеОшибки;
	КонецЕсли;
	
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацияФискальногоНакопителя_Продолжить(РезультатВыполнения, Параметры) Экспорт
	
	Если РезультатВыполнения <> Неопределено 
		И ТипЗнч(РезультатВыполнения) = Тип("Структура")
		И МенеджерОборудованияКлиентПовтИсп.ИспользуетсяЧекопечатающиеУстройства() Тогда
		
		ФискальноеУстройство = Объект.Ссылка;
		ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОперацияФискальногоНакопителя_Завершение", ЭтотОбъект);
		МодульОборудованиеЧекопечатающиеУстройстваКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОборудованиеЧекопечатающиеУстройстваКлиент");
		МодульОборудованиеЧекопечатающиеУстройстваКлиент.НачатьОперациюФНДляФискальногоУстройства(ОповещениеПриЗавершении,
			УникальныйИдентификатор, ФискальноеУстройство, РезультатВыполнения); 
			
	КонецЕсли;
	
	ЭтотОбъект.Прочитать();
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацияФискальногоНакопителя(КодОперации)
	
#Если ВебКлиент Тогда
	ПоказатьПредупреждение(, НСтр("ru='Данный функционал доступен только в режиме тонкого и толстого клиента.'"));
	Возврат;
#КонецЕсли
	
	ФискальноеУстройство = Объект.Ссылка;
	Если Не ЗначениеЗаполнено(ФискальноеУстройство) Тогда
		Возврат;
	КонецЕсли;               
	
	ПараметрыОперации = Новый Структура("ФискальноеУстройство, Организация, ТипОперации", ФискальноеУстройство, Объект.Организация, КодОперации);
	Обработчик = Новый ОписаниеОповещения("ОперацияФискальногоНакопителя_Продолжить", ЭтотОбъект);
	ОткрытьФорму("Справочник.ПодключаемоеОборудование.Форма.ПараметрыФискализации", ПараметрыОперации,,,,,Обработчик, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДрайверов()
	
	Элементы.ДрайверОборудования.СписокВыбора.Очистить();
	
	ДрайвераОборудования = МенеджерОборудованияВызовСервера.ДрайвераПоТипуОборудования(Объект.ТипОборудования);
	Для Каждого ДрайверОборудования Из ДрайвераОборудования Цикл
		Элементы.ДрайверОборудования.СписокВыбора.Добавить(ДрайверОборудования.Значение, ДрайверОборудования.Представление);
	КонецЦикла;
	
	Объект.ДрайверОборудования = ПредопределенноеЗначение("Справочник.ДрайверыОборудования.ПустаяСсылка");
	Объект.Наименование = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНавигационнуюСсылку(НавигационнаяСсылка, Знач Оповещение = Неопределено)
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		// Особенность платформы: ПерейтиПоНавигационнойСсылке не доступен в толстом клиенте обычного приложения.
		Оповещение = Новый ОписаниеОповещения;
		НачатьЗапускПриложения(Оповещение, НавигационнаяСсылка); // АПК:534 передаются фиксированные строки
	#Иначе
		ПерейтиПоНавигационнойСсылке(НавигационнаяСсылка); // АПК:534 передаются фиксированные строки
	#КонецЕсли

КонецПроцедуры

#КонецОбласти
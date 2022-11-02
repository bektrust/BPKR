
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОфлайнОборудованияПереопределяемый.ФормаОбменСОфлайнОборудованиемПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область ОбработчикиКомандФормыККМ

&НаКлиенте
Процедура ВыгрузитьДанные(Команда)
	
	ТекущиеДанные = Элементы.СписокОборудования.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		
		МенеджерОфлайнОборудованияКлиент.НачатьВыгрузкуДанныхНаККМ(ТекущиеДанные.Ссылка, УникальныйИдентификатор, Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьНастройки(Команда)
	
	ТекущиеДанные = Элементы.СписокОборудования.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		МенеджерОфлайнОборудованияКлиент.НачатьВыгрузкуНастроекНаККМ(ТекущиеДанные.Ссылка, УникальныйИдентификатор, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьПолныйПрайсЛист(Команда)
	
	ТекущиеДанные = Элементы.СписокОборудования.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		
		МенеджерОфлайнОборудованияКлиент.НачатьПолнуюВыгрузкуПрайсЛистаНаККМ(ТекущиеДанные.Ссылка, УникальныйИдентификатор, Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПрайсЛист(Команда)
	
	ТекущиеДанные = Элементы.СписокОборудования.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		
		МенеджерОфлайнОборудованияКлиент.НачатьОчисткуПрайсЛистаНаККМ(ТекущиеДанные.Ссылка, УникальныйИдентификатор, Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанные(Команда)
	
	ТекущиеДанные = Элементы.СписокОборудования.ТекущиеДанные;
	ОповещениеПриЗавершении = Неопределено;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		
			
		МенеджерОфлайнОборудованияКлиент.НачатьЗагрузкуДанныхИзККМ(ТекущиеДанные.Ссылка, УникальныйИдентификатор, ОповещениеПриЗавершении);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОтчетыЗаПериод(Команда)
	
	ТекущиеДанные = Элементы.СписокОборудования.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		
		
		ТекстСообщения = НСтр("ru='Для данного типа устройства данная команда недоступна.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОтчетЗаПериодЗавершение(Результат, Параметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		
		Если Результат.Результат Тогда
			ТекстСообщения = НСтр("ru='Данные загружены успешно'");
		Иначе
			ТекстСообщения = Результат.ОписаниеОшибки;
		КонецЕсли;
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
#КонецОбласти
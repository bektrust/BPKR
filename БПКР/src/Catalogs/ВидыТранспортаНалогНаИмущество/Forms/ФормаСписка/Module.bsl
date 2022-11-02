
#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Копирование Тогда 
		Возврат;
	КонецЕсли;	
	
	Отказ = Истина;
	
	ВопросПодобратьИзСервиса();		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПодборИзКлассификатора(Команда)
	ПодобратьИзКлассификатора();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Асинх Процедура ВопросПодобратьИзСервиса()
	ТекстВопроса = НСтр("ru = 'Есть возможность подобрать из сервиса.
		|Подобрать?'");
	
	Ответ = Ждать ВопросАсинх(ТекстВопроса, РежимДиалогаВопрос.ДаНет, 30);
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПодобратьИзКлассификатора();
	Иначе
		ОткрытьФорму("Справочник.ВидыТранспортаНалогНаИмущество.Форма.ФормаЭлемента",, ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
&НаКлиенте
Процедура ПодобратьИзКлассификатора()
	ОбщегоНазначенияБПКлиент.ОткрытьФормуПодбораИзКлассификатора(
		"ВидыТранспортаНалогНаИмущество", 
		"TransportTypesGetService", 
		НСтр("ru = 'Виды транспорта (налог на имущество)'"), 
		ЭтаФорма,
		,
		,
		"Справочники.ВидыТранспортаНалогНаИмущество.ЗаполнитьСтавкиВидовТранспорта");
КонецПроцедуры

#КонецОбласти

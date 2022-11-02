
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	СписокСОтборомПоВладельцу = Параметры.Свойство("СписокСОтборомПоВладельцу") И Параметры.СписокСОтборомПоВладельцу;
	
	ОтображатьПродукцию = ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Или Не СписокСОтборомПоВладельцу;
	
	НастроитьЗаголовокИВидимостьЭлементовФормы(Параметры.ОткрытоИзКарточкиНоменклатуры, ОтображатьПродукцию);
	
	// КопированиеСтрокТабличныхЧастей
	КопированиеТабличнойЧастиСервер.ПриСозданииНаСервере(Элементы, "ИсходныеКомплектующие");
	// Конец КопированиеСтрокТабличныхЧастей
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// КопированиеСтрокТабличныхЧастей
	Если ИмяСобытия = "БуферОбменаТабличнаяЧастьКопированиеСтрок" Тогда
		КопированиеТабличнойЧастиКлиент.ОбработкаОповещения(Элементы, "ИсходныеКомплектующие");
	КонецЕсли;
	// Конец КопированиеСтрокТабличныхЧастей
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьПараметрЗаписиНоменклатураПредыдущийВладелец(ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ЗаполнитьПараметрыЗаписиДляОповещения(ТекущийОбъект, ПараметрыЗаписи);	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)	
	
	Оповестить("ЗаписанаСпецификацияНоменклатуры", ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьЗаголовокИВидимостьЭлементовФормы(ОткрытоИзКарточкиНоменклатуры, ОтображатьПродукцию)
	
	Если ОткрытоИзКарточкиНоменклатуры Тогда
		ЭтотОбъект.Заголовок = СтрШаблон(НСтр("ru = '%1 (%2)'"),НСтр("ru = 'Материалы'"), Объект.Наименование);
	Иначе
		ЭтотОбъект.Заголовок = Метаданные.Справочники.СпецификацииНоменклатуры.РасширенноеПредставлениеОбъекта;
	КонецЕсли;
	
	Элементы.Наименование.Видимость = Не ОткрытоИзКарточкиНоменклатуры;
	
	Если ОткрытоИзКарточкиНоменклатуры Или Не ОтображатьПродукцию Тогда
		
		// Продукция видна "на заднем фоне". Форма блокирующая, продукция в форме не выводится
		Элементы.Владелец.Видимость  = Ложь;
		ЭтотОбъект.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		
		// У блокирующих форм кнопки внизу
		Элементы.ГруппаДействияФормы.Видимость   = Истина;
		Элементы.ГруппаКоманднаяПанель.Видимость = Ложь;
		
	Иначе
		
		Элементы.Владелец.Видимость  = Истина;
		ЭтотОбъект.РежимОткрытияОкна = РежимОткрытияОкнаФормы.Независимый;
		
		Элементы.ГруппаДействияФормы.Видимость   = Ложь;
		Элементы.ГруппаКоманднаяПанель.Видимость = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьПараметрЗаписиНоменклатураПредыдущийВладелец(СправочникОбъект, ПараметрыЗаписи)
	
	Если СправочникОбъект.ЭтоНовый() Тогда
		Возврат;
	КонецЕсли;
	
	ПредыдущийВладелец = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СправочникОбъект.Ссылка, "Владелец");
	Если ПредыдущийВладелец <> СправочникОбъект.Владелец Тогда
		
		ПараметрыЗаписи.Вставить("НоменклатураПредыдущийВладелец", ПредыдущийВладелец);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьПараметрыЗаписиДляОповещения(СправочникОбъект, ПараметрыЗаписи)
	
	СпецификацияПредставление = УправлениеПроизводством.ПредставлениеОсновнойСпецификации(СправочникОбъект.Ссылка);
	
	ПараметрыЗаписи.Вставить("СпецификацияПредставление", СпецификацияПредставление);
	ПараметрыЗаписи.Вставить("ИзмененнаяСпецификация",    СправочникОбъект.Ссылка);
	ПараметрыЗаписи.Вставить("НоменклатураВладелец",      СправочникОбъект.Владелец);
	
КонецПроцедуры

#КонецОбласти

#Область КопированиеСтрокТабличныхЧастей

&НаКлиенте
Процедура ИсходныеКомплектующиеКопироватьСтроки(Команда)
	
	КопироватьСтроки("ИсходныеКомплектующие");
	
КонецПроцедуры

&НаКлиенте
Процедура ИсходныеКомплектующиеВставитьСтроки(Команда)
	
	ВставитьСтроки("ИсходныеКомплектующие");
	
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

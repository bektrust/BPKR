#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТолькоПросмотр = НЕ ПравоДоступа("Изменение", Метаданные.ПланыСчетов.Хозрасчетный);
	Элементы.ЗаписатьИЗакрыть.Видимость = НЕ ТолькоПросмотр;
	
	ПараметрыУчета = ОбщегоНазначенияБПСервер.ОпределитьПараметрыУчета();
	
	ИспользоватьСтатьиДвиженияДенежныхСредств = ПараметрыУчета.ВестиУчетПоСтатьямДДС И ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиДвиженияДенежныхСредств");
	ИспользоватьСтатьиДвиженияДенежныхСредствИсходноеЗначение = ИспользоватьСтатьиДвиженияДенежныхСредств;
	УказыватьСтатьиДДСДляВнутреннихОборотов = Константы.УказыватьСтатьиДДСДляВнутреннихОборотов.Получить();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		ТекстВопроса = НСтр("ru='Данные были изменены. Сохранить изменения?'");
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьСтатьиДвиженияДенежныхСредствПриИзменении(Элемент)
	УправлениеФормой(ЭтаФорма);
	
	Если НЕ ИспользоватьСтатьиДвиженияДенежныхСредств Тогда
		УказыватьСтатьиДДСДляВнутреннихОборотов = Ложь;
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьИзменения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВопросПередЗаписьюЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПрименитьНастройкуСубконто();
		УстановитьЗначениеКонстанты();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаписатьИзменения();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Если Форма.ИспользоватьСтатьиДвиженияДенежныхСредств Тогда
		Форма.Элементы.ГруппаПредупреждениеАктивно.Видимость = Ложь;
		Форма.Элементы.УказыватьСтатьиДДСДляВнутреннихОборотов.Видимость = Истина;
	Иначе
		Форма.Элементы.ГруппаПредупреждениеАктивно.Видимость = Истина;
		Форма.Элементы.УказыватьСтатьиДДСДляВнутреннихОборотов.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИзменения()
		
	ПараметрыУчета.ВестиУчетПоСтатьямДДС = ИспользоватьСтатьиДвиженияДенежныхСредств;
	
	ДополнительныеПараметры = ОбщегоНазначенияБПКлиентСервер.ПолучитьСтруктуруДополнительныхПараметров();
	ДополнительныеПараметры.УчетДС = Истина;

	ТекстВопроса = ОбщегоНазначенияБПВызовСервера.ПолучитьТекстВопросаПриУдаленииСубконто(ПараметрыУчета, ДополнительныеПараметры);
	Если ПустаяСтрока(ТекстВопроса) Тогда
		ПрименитьНастройкуСубконто();
		УстановитьЗначениеКонстанты();
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВопросПередЗаписьюЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьНастройкуСубконто(Отказ = Ложь)
	
	ПрименитьНастройкуСубконтоНаСервере(Отказ);
	
	Если НЕ Отказ Тогда
		Модифицированность = Ложь;
		Оповестить("ИзменениеНастройкиПланаСчетов");
		Оповестить("ИзменениеНастроекПараметровУчета");
		Оповестить("Запись_НаборКонстант");
		ОповеститьОбИзменении(Тип("ПланСчетовСсылка.Хозрасчетный"));
		ПоказатьОповещениеПользователя(НСтр("ru = 'Изменены параметры субконто'"), 
			"e1cib/app/Обработка.ЖурналРегистрации", "Журнал регистрации");
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрименитьНастройкуСубконтоНаСервере(Отказ = Ложь)
	
	ДополнительныеПараметры = ОбщегоНазначенияБПКлиентСервер.ПолучитьСтруктуруДополнительныхПараметров();
	ДополнительныеПараметры.УчетДС = Истина;
	ОбщегоНазначенияБПСервер.ПрименитьПараметрыУчета(ПараметрыУчета, ДополнительныеПараметры, Истина, Отказ);
	
	Константы.ИспользоватьСтатьиДвиженияДенежныхСредств.Установить(ИспользоватьСтатьиДвиженияДенежныхСредств);
	Константы.НЕИспользоватьСтатьиДвиженияДенежныхСредств.Установить(НЕ ИспользоватьСтатьиДвиженияДенежныхСредств);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначениеКонстанты()

	Константы.УказыватьСтатьиДДСДляВнутреннихОборотов.Установить(УказыватьСтатьиДДСДляВнутреннихОборотов);	

КонецПроцедуры

#КонецОбласти

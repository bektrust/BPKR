#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РазрешеноИзменение = НЕ ПравоДоступа("Изменение", Метаданные.Константы.НастройкаЗаполненияЦены);	
	Элементы.ИзПредыдущегоДокумента.ТолькоПросмотр = РазрешеноИзменение; // Отключено сохранение данных, т.к. это приводит к установке модифицированности
	Элементы.ИзКарточкиНоменклатуры.ТолькоПросмотр = РазрешеноИзменение;
	
	НастройкаЦены = Константы.НастройкаЗаполненияЦены.Получить();	
	Элементы.ПодсказкаОНастройкахФормы.Видимость = Параметры.ОткрытаИзКарточкиНоменклатуры;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НастройкаЦеныПриИзменении(Элемент)
	
	НастройкаЦеныПриИзмененииНаСервере(НастройкаЦены);
	Оповестить("ФормаНастройкаЦеныИзменена");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура НастройкаЦеныПриИзмененииНаСервере(НастройкаЦены)
	
	Константы.НастройкаЗаполненияЦены.Установить(НастройкаЦены);
	
КонецПроцедуры

#КонецОбласти
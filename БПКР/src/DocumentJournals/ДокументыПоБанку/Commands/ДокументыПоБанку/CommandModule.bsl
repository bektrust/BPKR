#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОткрытьФорму("ЖурналДокументов.ДокументыПоБанку.ФормаСписка", , ПараметрыВыполненияКоманды.Источник, 
	ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры

#КонецОбласти
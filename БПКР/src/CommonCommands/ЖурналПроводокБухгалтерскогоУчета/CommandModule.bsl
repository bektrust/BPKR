#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Отбор = Новый Структура;
	Отбор.Вставить("Регистратор", ПараметрКоманды);
	
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	
	ОткрытьФорму("РегистрБухгалтерии.Хозрасчетный.ФормаСписка", ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, 
			ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
			
КонецПроцедуры

#КонецОбласти
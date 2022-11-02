#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.СсылкаСуществует(Ссылка) И Не ДополнительныеСвойства.Свойство("ПодборИзКлассификатора") Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Добавление языка доступно только подбором из классификатора.'"), , , , Отказ);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
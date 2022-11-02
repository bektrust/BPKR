#Область СлужебныйПрограммныйИнтерфейс

// Определяет, насколько период отчета обычно отличается от периода, включающего сегодняшний день.
//
// Параметры:
//  ИмяОтчета	 - Строка - Имя отчета.
// 
// Возвращаемое значение:
//  Число - смещение в месяцах, отрицательное для завершившихся периодов.
//
Функция СмещениеПериодаОтчета(ИмяОтчета) Экспорт
	
	ПериодОтчета = Новый Структура;
	ПериодОтчета.Вставить("Продажи", -3);
	ПериодОтчета.Вставить("ПродажиПоМесяцам", -36);
	ПериодОтчета.Вставить("ПоступленияДенежныхСредств", -3);
	ПериодОтчета.Вставить("РасходыДенежныхСредств", -3);
	ПериодОтчета.Вставить("ДоходыРасходы", -3);
	ПериодОтчета.Вставить("ОборотныеСредства", -3);
	ПериодОтчета.Вставить("ДинамикаЗадолженностиПокупателей", -3);
	ПериодОтчета.Вставить("ДинамикаЗадолженностиПоставщикам", -3);
	
	Смещение = 0;
	Если ПериодОтчета.Свойство(ИмяОтчета, Смещение) Тогда
		Возврат Смещение;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

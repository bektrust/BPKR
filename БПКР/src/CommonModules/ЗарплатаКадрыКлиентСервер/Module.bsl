
#Область СлужебныйПрограммныйИнтерфейс

// Возвращает Истина, если переданный объект содержит 
// значения по умолчанию для удостоверения личности
//
// Параметры:
//	ИнформацияОбУдостоверенииЛичности - объект, имеющий свойства 
//		ВидДокумента
//		Серия
//		Номер
//		ДатаВыдачи
//		КемВыдан
//		КодПодразделения
//		
Функция УдостоверениеЛичностиПоУмолчанию(ИнформацияОбУдостоверенииЛичности) Экспорт
	
	Возврат (НЕ ЗначениеЗаполнено(ИнформацияОбУдостоверенииЛичности.ВидДокумента))
		И (НЕ ЗначениеЗаполнено(ИнформацияОбУдостоверенииЛичности.Серия))
		И (НЕ ЗначениеЗаполнено(ИнформацияОбУдостоверенииЛичности.Номер))
		И (НЕ ЗначениеЗаполнено(ИнформацияОбУдостоверенииЛичности.ДатаВыдачи))
		И (НЕ ЗначениеЗаполнено(ИнформацияОбУдостоверенииЛичности.СрокДействия))
		И (НЕ ЗначениеЗаполнено(ИнформацияОбУдостоверенииЛичности.КемВыдан))
		И (НЕ ЗначениеЗаполнено(ИнформацияОбУдостоверенииЛичности.КодПодразделения));
		
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Универсальный механизм "Месяц строкой"

// Заполняет реквизит представлением месяца, хранящегося в другом реквизите
//
// Параметры:
//		РедактируемыйОбъект
//		ПутьРеквизита - Строка, путь к реквизиту, содержащего дату
//		ПутьРеквизитаПредставления - Строка, путь к реквизиту в который помещается представление месяца
//
Процедура ЗаполнитьМесяцПоДате(РедактируемыйОбъект, ПутьРеквизита, ПутьРеквизитаПредставления) Экспорт
	
	Значение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита);
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизитаПредставления, ПолучитьПредставлениеМесяца(Значение));
	
КонецПроцедуры

// Возвращает представление месяца по переданной дате
//
// Параметры:
//		ДатаНачалаМесяца
//
// Возвращаемое значение;
//		Строка
//
Функция ПолучитьПредставлениеМесяца(ДатаНачалаМесяца) Экспорт
	
	Возврат Формат(ДатаНачалаМесяца, "ДФ='ММММ гггг'");
	
КонецФункции

#КонецОбласти	

#Область СлужебныеПроцедурыИФункции

Функция ДатаОтсчетаПериодическихСведений() Экспорт
	
	Возврат '18991231000000';
	
КонецФункции

#КонецОбласти

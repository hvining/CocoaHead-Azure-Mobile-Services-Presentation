exports.get = function(request, response) {
    var userId = request.query.userId;
    
    if(userId === undefined)
    {
        response.send(405, "Not allowed");
        return;
    }
    
    var todoLists = [];
    
    var todoItemsByListId = function(todoItemIndex)
    {
        if(todoItemIndex >= todoLists.length)
        {
            response.send(200, todoLists);   
            return;
        }
        var todoList = todoLists[todoItemIndex];
        request.service.tables.getTable("TodoItem").where({todolistId:todoList.id}).read({success:function(todoItems){
            todoList.todoItems = todoItems;
            todoItemsByListId(todoItemIndex + 1);
        }});
    }
    
    request.service.tables.getTable("TodoList").where({userId:userId}).read({success: function(lists)
    {
        todoLists = lists;
        todoItemsByListId(0);
    }});
};
import azure.functions as func
import csv,io,json
app=func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)

@app.route(route='validate',methods=['POST'])
def validate(req:func.HttpRequest)->func.HttpResponse:
    try:
        reader=csv.DictReader(io.StringIO(req.get_body().decode('utf-8-sig')))
        if not {'id','value'}.issubset(reader.fieldnames or []):
            raise ValueError('CSV requires id and value columns')
        rows=list(reader)
        if any(not row.get('id') or not row.get('value') for row in rows):
            raise ValueError('Rows require id and value')
        return func.HttpResponse(json.dumps({'valid':True,'rows':len(rows)}),mimetype='application/json')
    except (ValueError,UnicodeDecodeError) as error:
        return func.HttpResponse(json.dumps({'valid':False,'error':str(error)}),status_code=400,mimetype='application/json')

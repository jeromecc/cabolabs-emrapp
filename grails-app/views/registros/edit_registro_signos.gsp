<html>
  <head>
    <meta name="layout" content="main" />
    <title>Registro de signos</title>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'css/ui-lightness', file: 'jquery-ui-1.8.24.custom.css')}" />
    <link rel="stylesheet" type="text/css" href="${resource(dir:'css', file:'emr.css')}" />
    <style type="text/css">
      body {
        padding: 10px;
        margin-top: 10px;
      }
      h1 {
        border-bottom: 1px solid #DFDFDF;
        padding-bottom: 5px;
      }
      form {
        margin: 0 17%;
      }
      form > table {
        border: 0; /* saca el border top de la table que lo puse como border bottom del h1 */
      }
      .content {
        /*padding: 10px;*/
      }
      td {
        white-space:nowrap;
      }
      tr > td:first-child {
        text-align: right;
      }
      tr:last-child td {
        /*text-align: center;*/
      }
      input[type=radio] {
        margin: 0 5px 0 0;
      }
      input[readonly=readonly] {
        border: 0;
        background: none;
      }
      label {
        margin: 0 5px 0 5px;
      }
      .magnitude_constraint {
        display: none;
      }
    </style>
    <g:javascript src="jquery-1.8.2.min.js" />
    <g:javascript src="jquery-ui-1.8.24.autocomplete.min.js" />
    
    <g:javascript>
    
    $(document).ready(function() {
      
    });
    
    $("input[type=radio]").live( "click", function () {
    
      var name = $(this).attr("name"); // ej. presion_sistolica_units
      var pos = name.lastIndexOf("_");
      var field = name.substring(0,pos); // queda presion_sistolica
      
      
      // habria que apagar si hay alguno mostrandose ahora
      //temperatura_magnitude_constraint
      $( "#"+field+"_magnitude_constraint" ).children().hide(); // esconde todas las constraints
      
      
      // id="temperatura_(cdvq_item.units)"
      $( "#"+field+"_"+$(this).val() ).show();
      
      
      //console.log( $(this).val() );
      //console.log($(this).attr("name").lastIndexOf("_"));
    });
    
    </g:javascript>
  </head>
  <body>
    <div class="nav" role="navigation">
      <ul>
        <li><g:link class="list" controller="registros" action="currentSession">Registros</g:link></li>
      </ul>
      <g:render template="/user/loggedUser" />
    </div>
    
    <g:render template="patientData" model="[patientInstance: session.clinicalSession.patient]" />
  
    <h1>Registro de signos</h1>

    <p>Está editando el documento ${doc.versionUid}</p>

    <div class="content">
      <g:form action="save">
        <input type="hidden" name="templateId" value="${template.templateId}"/>
        <input type="hidden" name="operation" value="edit"/>
        <input type="hidden" name="id" value="${doc.id}"/>
        
        <table>
          <g:set var="node" value="${template.getNode( bindings['presion_sistolica'] )}" />
          <!-- <textarea>${groovy.xml.XmlUtil.serialize(node.xmlNode)}</textarea> -->
          <tr>
            <td>
              Presión sistólica:
              <g:if test="${node?.xmlNode.list.size() == 1}">
                <g:if test="${node.xmlNode.list[0].magnitude}">
                (${node?.xmlNode.list[0].magnitude.lower}..${node?.xmlNode.list[0].magnitude.upper})
                </g:if>
              </g:if>
              <g:else>
                <!-- TODO: al cambiar la unidad seleccionada, poner el rango respectivo si esta definido. -->
              </g:else>
            </td>
            <td>
              <input type="text" name="presion_sistolica_mag" id="presion_sistolica_mag" value="${doc.bindData[ bindings['presion_sistolica_mag'] ]}" />
            </td>
            <td>
              <%--
              ${bindings['presion_sistolica_units']}<br/>
              ${node} CDvQuantity<br/>
              ${node?.list} List CDvQuantityItem<br/>
              --%>
             
              <%--
              TODO: si hay un solo item, mostrarlo como label con hidden
              TODO: taglib
              --%>
              <g:if test="${node?.xmlNode.list.size() == 1}">
                <input type="text" value="${node?.xmlNode.list[0].units.text()}" readonly="readonly" name="presion_sistolica_units" />
              </g:if>
              <g:else>
                <g:each in="${node?.xmlNode.list}" var="item">
                  
                  <%--
                  ${item as grails.converters.XML}
                  /* item:
                    <?xml version="1.0" encoding="UTF-8"?>
                    <CDvQuantityItem>
                      <class>org.openehr.am.openehrprofile.datatypes.quantity.CDvQuantityItem</class>
                      <magnitude>
                        <class>org.openehr.rm.support.basic.Interval</class>
                        <lower>0.0</lower><lowerIncluded>true</lowerIncluded>
                        <lowerUnbounded>false</lowerUnbounded>
                        <upper>400.0</upper>
                        <upperIncluded>true</upperIncluded>
                        <upperUnbounded>false</upperUnbounded>
                      </magnitude>
                      <precision />
                      <units>mm[Hg]</units>
                    </CDvQuantityItem>
                  */
                  --%>
                  
                  <label><input type="radio" value="${item.units.text()}" name="presion_sistolica_units" ${((doc.bindData[ bindings['presion_sistolica_units'] ] == item.units.text() ) ? 'checked="checked"':'')}" />${item.units.text()}</label>
                </g:each>
              </g:else>
            </td>
          </tr>
          
          <g:set var="node" value="${template.getNode( bindings['presion_diastolica'])}" />
          <tr>
            <td>
              Presión diastólica:
              <g:if test="${node?.xmlNode.list.size() == 1}">
                <g:if test="${node.xmlNode.list[0].magnitude}">
                (${node?.xmlNode.list[0].magnitude.lower}..${node?.xmlNode.list[0].magnitude.upper})
                </g:if>
              </g:if>
              <g:else>
                TODO: al cambiar la unidad seleccionada, poner el rango respectivo si esta definido.
              </g:else>
            </td>
            <td>
              <input type="text" name="presion_diastolica_mag" id="presion_diastolica_mag" value="${doc.bindData[ bindings['presion_diastolica_mag'] ]}" />
            </td>
            <td>
              <g:if test="${node?.xmlNode.list.size() == 1}">
                <input type="text" value="${node?.xmlNode.list[0].units}" readonly="readonly" name="presion_diastolica_units" />
              </g:if>
              <g:else>
                <g:each in="${node?.xmlNode.list}" var="item">
                  <label><input type="radio" value="${item.units.text()}" name="presion_diastolica_units" ${((doc.bindData[ bindings['presion_diastolica_units'] ] == item.units.text() ) ? 'checked="checked"':'')} />${item.units.text()}</label>
                </g:each>
              </g:else>
            </td>
          </tr>
          
          <g:set var="node" value="${template.getNode( bindings['temperatura'])}" />
          <tr>
            <td>
              Temperatura:
              <span id="temperatura_magnitude_constraint">
	             <g:if test="${node?.xmlNode.list.size() == 1}">
	               <g:if test="${node?.xmlNode.list[0].magnitude}">
	                 (${node?.xmlNode.list[0].magnitude.lower}..${node?.xmlNode.list[0].magnitude.upper})
	               </g:if>
	             </g:if>
	             <g:else>
	               <g:each in="${node?.xmlNode.list}" var="cdvq_item">
	                 <span class="magnitude_constraint" id="temperatura_${cdvq_item.units}">
	                   <g:if test="${node?.xmlNode.list[0].magnitude}">
	                     (${cdvq_item.magnitude.lower}..${cdvq_item.magnitude.upper})
	                   </g:if>
	                 </span>
	               </g:each>
	             </g:else>
              </span>
            </td>
            <td>
              <input type="text" name="temperatura_mag" id="temperatura_mag" value="${doc.bindData[ bindings['temperatura_mag'] ]}" />
            </td>
            <td>
              <g:if test="${node?.xmlNode.list.size() == 1}">
                <input type="text" value="${node?.xmlNode.list[0].units.text()}" readonly="readonly" name="temperatura_units" />
              </g:if>
              <g:else>
                <g:each in="${node?.xmlNode.list}" var="item">
                  <label><input type="radio" value="${item.units.text()}" name="temperatura_units" ${((doc.bindData[ bindings['temperatura_units'] ] == item.units.text() ) ? 'checked="checked"':'')} />${item.units.text()}</label>
                </g:each>
              </g:else>
            </td>
          </tr>
          
          <!--
           this node has constraints for the name and the value
           the difference from this to the respiratory frequency is
           that the path in the binding her epoints to an ELEMENT, but
           on the respiratory points to the ELEMENT.value, so the code
           is a little different, here we need the ELEMENT because we
           also need the constraint for the ELEMENT.name
          -->
          <g:set var="node" value="${template.getNode(bindings['frecuencia_cardiaca'])}" />
          <g:set var="name" value="${node.attributes.find{ it.rmAttributeName == "name" }.children[0]}" />
          <g:set var="value" value="${node.attributes.find{ it.rmAttributeName == 'value' }.children[0]}" />
          <tr>
            <td>
              Frecuencia cardíaca:
              <g:if test="${value.xmlNode.list.size() == 1}">
                <g:if test="${value.xmlNode.list[0].magnitude}">
                (${value.xmlNode.list[0].magnitude.lower}..${value.xmlNode.list[0].magnitude.upper})
                </g:if>
              </g:if>
              <g:else>
                <!-- TODO: al cambiar la unidad seleccionada, poner el rango respectivo si esta definido. -->
              </g:else>
            </td>
            <td>
              <!-- 
              1. ${bindings['frecuencia_cardiaca_name']}<br/>
              2. ${doc.bindData}<br/>
              3. ${doc.bindData[ bindings['frecuencia_cardiaca_name'] ]}<br/>
              -->
              <g:each in="${name?.attributes.find{ it.rmAttributeName == "defining_code" }.children[0].xmlNode.code_list}" var="code">
                <!-- 
                code. ${code.text()}<br/>
                -->
                <label><input type="radio" value="${code.text()}" name="frecuencia_cardiaca_name" ${((doc.bindData[ bindings['frecuencia_cardiaca_name'] ] == code.text() ) ? 'checked="checked"':'')} />${template.getTerm('openEHR-EHR-OBSERVATION.pulse.v1', code.text())}</label>
              </g:each>
              <br/>
              
              <input type="text" name="frecuencia_cardiaca_mag" id="frecuencia_cardiaca_mag" value="${doc.bindData[ bindings['frecuencia_cardiaca_mag'] ]}" />
            </td>
            <td>
              <g:if test="${value.xmlNode.list.size() == 1}">
                <input type="text" value="${value.xmlNode.list[0].units}" readonly="readonly" name="frecuencia_cardiaca_units" />
              </g:if>
              <g:else>
                <g:each in="${value.xmlNode.list}" var="item">
                  <label><input type="radio" value="${item.units.text()}" name="frecuencia_cardiaca_units" ${((doc.bindData[ bindings['frecuencia_cardiaca_units'] ] == item.units.text() ) ? 'checked="checked"':'')} />${item.units.text()}</label>
                </g:each>
              </g:else>
            </td>
          </tr>
          
          <g:set var="node" value="${template.getNode(bindings['frecuencia_respiratoria'])}" />
          <tr>
            <td>
              Frecuencia respiratoria:
              <g:if test="${node?.xmlNode.list.size() == 1}">
                <g:if test="${node.xmlNode.list[0].magnitude}">
                (${node?.xmlNode.list[0].magnitude.lower}..${node?.xmlNode.list[0].magnitude.upper})
                </g:if>
              </g:if>
              <g:else>
                <!-- TODO: al cambiar la unidad seleccionada, poner el rango respectivo si esta definido. -->
              </g:else>
            </td>
            <td>
              <input type="text" name="frecuencia_respiratoria_mag" id="frecuencia_respiratoria_mag" value="${doc.bindData[ bindings['frecuencia_respiratoria_mag'] ]}" />
            </td>
            <td>
              <g:if test="${node?.xmlNode.list.size() == 1}">
                <input type="text" value="${node?.xmlNode.list[0].units.text()}" readonly="readonly" name="frecuencia_respiratoria_units" />
              </g:if>
              <g:else>
                <g:each in="${node?.xmlNode.list}" var="item">
                  <label><input type="radio" value="${item.units.text()}" name="frecuencia_respiratoria_units" ${((doc.bindData[ bindings['frecuencia_respiratoria_units'] ] == item.units.text() ) ? 'checked="checked"':'')} />${item.units.text()}</label>
                </g:each>
              </g:else>
            </td>
          </tr>
          
          <g:set var="node" value="${template.getNode( bindings['peso'])}" />
          <tr>
            <td>
              Peso:
              <span id="peso_magnitude_constraint">
	             <g:if test="${node?.xmlNode.list.size() == 1}">
	                <g:if test="${node.xmlNode.list[0].magnitude}">
	                  (${node?.xmlNode.list[0].magnitude.lower}..${node?.xmlNode.list[0].magnitude.upper})
	                </g:if>
	              </g:if>
	              <g:else>
	                <!-- Al cambiar la unidad seleccionada, poner el rango respectivo si esta definido. -->
	                <g:each in="${node.xmlNode.list}" var="cdvq_item">
                    <span class="magnitude_constraint" id="peso_${cdvq_item.units}">
                      <g:if test="${node.xmlNode.list[0].magnitude}">
                        (${cdvq_item.magnitude.lower}..${cdvq_item.magnitude.upper})
                      </g:if>
                    </span>
                  </g:each>
	             </g:else>
              </span>
            </td>
            <td>
              <input type="text" name="peso_mag" id="peso_mag" value="${doc.bindData[ bindings['peso_mag'] ]}" />
            </td>
            <td>
              <g:if test="${node?.xmlNode.list.size() == 1}">
                <input type="text" value="${node?.xmlNode.list[0].units.text()}" readonly="readonly" name="peso_units" />
              </g:if>
              <g:else>
                <g:each in="${node?.xmlNode.list}" var="item">
                  <label><input type="radio" value="${item.units.text()}" name="peso_units" ${((doc.bindData[ bindings['peso_units'] ] == item.units.text() ) ? 'checked="checked"':'')} />${item.units.text()}</label>
                </g:each>
              </g:else>
            </td>
          </tr>
          
          <g:set var="node" value="${template.getNode( bindings['estatura'] )}" />
          <tr>
            <td>
              Estatura:
              <span id="estatura_magnitude_constraint">
	             <g:if test="${node?.xmlNode.list.size() == 1}">
	               <g:if test="${node.xmlNode.list[0].magnitude}">
	                 (${node?.xmlNode.list[0].magnitude.lower}..${node?.xmlNode.list[0].magnitude.upper})
	               </g:if>
	             </g:if>
	             <g:else>
	               <!-- Al cambiar la unidad seleccionada, poner el rango respectivo si esta definido. -->
                  <g:each in="${node.xmlNode.list}" var="cdvq_item">
                    <span class="magnitude_constraint" id="estatura_${cdvq_item.units}">
                      <g:if test="${cdvq_item.magnitude}">
                        (${cdvq_item.magnitude.lower}..${cdvq_item.magnitude.upper})
                      </g:if>
                    </span>
                  </g:each>
	             </g:else>
              </span>
            </td>
            <td>
              <input type="text" name="estatura_mag" id="estatura_mag" value="${doc.bindData[ bindings['estatura_mag'] ]}" />
            </td>
            <td>
              <g:if test="${node?.xmlNode.list.size() == 1}">
                <input type="text" value="${node?.list[0].units.text()}" readonly="readonly" name="estatura_units" />
              </g:if>
              <g:else>
                <g:each in="${node?.xmlNode.list}" var="item">
                  <label><input type="radio" value="${item.units.text()}" name="estatura_units" ${((doc.bindData[ bindings['estatura_units'] ] == item.units.text() ) ? 'checked="checked"':'')} />${item.units.text()}</label>
                </g:each>
              </g:else>
            </td>
          </tr>
          <tr>
            <td></td>
            <td></td>
            <td><input type="submit" value="Actualizar" /></td>
          </tr>
        </table>
      </g:form>
    </div>
  </body>
</html>